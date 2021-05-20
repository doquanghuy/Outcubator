//
//  WalletViewModel.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import Foundation
import RxSwift
 
protocol WalletVMInput {
    var didLoad: Observable<Void> {get}
    var didClickTopUp: Observable<Void> {get}
    var didClickVault: Observable<Void> {get}
    var didRefresh: Observable<Void> {get}
}

protocol WalletVMOutput {
    var balance: Observable<String> {get}
    var sections: Observable<[WalletSectionModel]> {get}
    var didCompleteRefreshing: Observable<Bool> {get}
    var didShowCurrencies: Observable<Void> {get}
}

protocol WalletVMInterface {
    func transform(input: WalletVMInput) -> WalletVMOutput
}

final class WalletVM: WalletVMInterface {
    typealias Tuple = (currency: String, trans: [Transaction])
    struct Input: WalletVMInput {
        var didLoad: Observable<Void>
        var didClickTopUp: Observable<Void>
        var didClickVault: Observable<Void>
        var didRefresh: Observable<Void>
    }
    
    struct Output: WalletVMOutput {
        var balance: Observable<String>
        var sections: Observable<[WalletSectionModel]>
        var didCompleteRefreshing: Observable<Bool>
        var didShowCurrencies: Observable<Void>
    }
    
    private let user: User
    private let walletUseCases: WalletUseCases
    private let actions: WalletActions
    
    init(user: User, walletUseCases: WalletUseCases, actions: WalletActions) {
        self.user = user
        self.walletUseCases = walletUseCases
        self.actions = actions
    }
    
    func transform(input: WalletVMInput) -> WalletVMOutput {
        let reload = PublishSubject<String>()

        let firstCurrency = input.didLoad
            .flatMap({self.loadCurrencies(user: self.user)})
            .map({$0.first!})
            .share()
        
        let currency = Observable.merge(firstCurrency, reload)
        
        let totalSections = Observable.merge([input.didLoad, input.didRefresh])
            .flatMap({self.loadTransactions(user: self.user)})
            .share()
        
        let firstSections = Observable.combineLatest(totalSections, currency)
            .map { (data) -> Tuple in
                return (data.1, data.0.filter {$0.currency == data.1})
            }
            .map({Array($0.trans.sorted(by: {$0.createdTime > $1.createdTime}).prefix(10))})
            .map({self.groupTransactionByTime(transactions: $0)})
        let reloadedSections = reload
            .asObservable()
            .withLatestFrom(totalSections){(currency: $0, trans: $1)}
            .map { (data) -> [Transaction] in
                return data.trans.filter {$0.currency == data.currency}
            }
            .map({Array($0.sorted(by: {$0.createdTime > $1.createdTime}).prefix(10))})
            .map({self.groupTransactionByTime(transactions: $0)})
        let sections = Observable.merge(firstSections, reloadedSections)
        
        let reloadedBalance = reload
            .withLatestFrom(totalSections){(currency: $0, trans: $1)}
            .map { (data) -> (currency: String, trans: [Transaction]) in
                return (data.currency, data.trans.filter {$0.currency == data.currency})
            }
            .map({(currency: $0.currency, sum: $0.trans.map{$0.amount * ($0.isCredit ? 1 : -1)}.reduce(0, +))})
            .map({"\($0.currency) \($0.sum.formattedWithSeparator)"})
        let firstBalance = Observable.combineLatest(totalSections, currency)
            .map { (data) -> (cur: String, trans: [Transaction]) in
                return (data.1, data.0.filter {$0.currency == data.1})
            }
            .map({(cur: $0.cur, sum: $0.trans.map{$0.amount * ($0.isCredit ? 1 : -1)}.reduce(0, +))})
            .map({"\($0.cur) \($0.sum.formattedWithSeparator)"})
        let balance = Observable.merge(reloadedBalance, firstBalance)
        
        let didShowCurrencies = input.didClickTopUp
            .flatMap({self.showCurrencies(reloadAction: reload)})
        
        let didCompleteRefreshing = totalSections
            .map({_ in false})
        
        return Output(balance: balance, sections: sections, didCompleteRefreshing: didCompleteRefreshing, didShowCurrencies: didShowCurrencies)
    }
    
    private func loadTransactions(user: User) -> Observable<[Transaction]> {
        return self.walletUseCases.loadTransactions(user: user.asDomain())
            .map { (domains) -> [Transaction] in
                return domains.map {Transaction(domain: $0)}
            }
    }
    
    private func groupTransactionByTime(transactions: [Transaction]) -> [WalletSectionModel] {
        var dict = [String: [Transaction]]()
        
        for transaction in transactions {
            dict[transaction.createdTime.asString, default: []].append(transaction)
        }
        
        return Array(dict.values)
            .sorted(by: {$0.first!.createdTime > $1.first!.createdTime})
            .map({WalletSectionModel(header: $0.first!.createdTime.asString, items: $0.sorted(by: {$0.createdTime > $1.createdTime}))})
    }
    
    private func loadCurrencies(user: User) -> Observable<[String]> {
        return self.walletUseCases.loadCurrencies(user: user.asDomain())
    }
    
    private func showCurrencies(reloadAction: PublishSubject<String>) -> Observable<Void> {
        return self.actions.showCurrencies(reloadAction)
    }
}

public struct WalletActions {
    let showCurrencies: (PublishSubject<String>) -> Observable<Void>
}
