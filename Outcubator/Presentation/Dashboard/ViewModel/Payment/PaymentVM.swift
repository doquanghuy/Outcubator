//
//  PaymentVM.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import Foundation
import RxSwift

protocol PaymentVMInput {
    var didLoad: Observable<Void> {get}
    var makePayment: Observable<Void> {get}
    var didClickBack: Observable<Void> {get}
}

protocol PaymentVMOutput {
    var didShowPopup: Observable<Void> {get}
    var didBack: Observable<Void> {get}
    var companyName: Observable<String> {get}
    var totalMoney: Observable<String> {get}
    var amount: Observable<String> {get}
    var fee: Observable<String> {get}
    var totalBalance: Observable<String> {get}
    var didShowError: Observable<Void> {get}
}

protocol PaymentVMInterface {
    func transform(input: PaymentVMInput) -> PaymentVMOutput
}

final class PaymentVM: PaymentVMInterface {
    struct Input: PaymentVMInput {
        var didClickBack: Observable<Void>
        var didLoad: Observable<Void>
        var makePayment: Observable<Void>
    }
    
    struct Output: PaymentVMOutput {
        var didBack: Observable<Void>
        var didShowPopup: Observable<Void>
        
        var companyName: Observable<String>
        var totalMoney: Observable<String>
        var amount: Observable<String>
        var fee: Observable<String>
        var totalBalance: Observable<String>
        var didShowError: Observable<Void>
    }
    
    private let qrCode: QRModel
    private let user: User
    private let actions: PaymentActions
    private let scanUseCases: ScanUseCases
    
    init(qrCode: QRModel, user: User, actions: PaymentActions, scanUseCases: ScanUseCases) {
        self.qrCode = qrCode
        self.actions = actions
        self.user = user
        self.scanUseCases = scanUseCases
    }
    
    func transform(input: PaymentVMInput) -> PaymentVMOutput {
        let qrCode = self.qrCode
        let reload = PublishSubject<Void>()
        let companyName = input.didLoad
            .map({qrCode.companyName})
        let amountNum = input.didLoad
            .map({qrCode.amount})

        let feeNum = input.didLoad
            .map({qrCode.fee})

        let totalNum = Observable.combineLatest(amountNum, feeNum) {(amount, fee) in
            return amount + fee
        }
        
        let amount = amountNum
            .map({String(format: "%@ %@", qrCode.currency, $0.formattedWithSeparator)})
        
        let fee = feeNum
            .map({String(format: "%@ %@", qrCode.currency, $0.formattedWithSeparator)})
        
        let total = totalNum
            .map({String(format: "%@ %@", qrCode.currency, $0.formattedWithSeparator)})

        let balanceNum = Observable.merge(input.didLoad, reload.asObservable())
            .flatMap({self.getCurrentBalance()})
        
        let balance = balanceNum
            .map({String(format: "%@ %@", qrCode.currency, $0.formattedWithSeparator)})

        let didBack = input.didClickBack
            .flatMap({self.back()})
        
        let isValidated = Observable.combineLatest(totalNum, balanceNum){(total: $0, balance: $1)}
            .map({$0.total <= $0.balance})
        
        let didMakePayment = input.makePayment
            .withLatestFrom(isValidated)
       
        let didShowError = didMakePayment
            .filter({!$0})
            .flatMap({_ in self.showError()})
        
        let didShowPopup = didMakePayment
            .filter({$0})
            .flatMap({_ in self.makePayment()})
            .filter({$0 != nil})
            .flatMap({self.showSuccess(transaction: $0!, reload: reload)})
            
        return Output(didBack: didBack, didShowPopup: didShowPopup, companyName: companyName, totalMoney: total, amount: amount, fee: fee, totalBalance: balance, didShowError: didShowError)
    }
    
    private func makePayment() -> Observable<Transaction?> {
        return self.scanUseCases
            .makePayment(qrCode: qrCode.asDomain(), user: user.asDomain())
            .map({Transaction(domain: $0)})
    }
    
    private func getCurrentBalance() -> Observable<Double> {
        return scanUseCases.transactions(user: self.user.asDomain())
            .map({$0.filter{$0.currency == self.qrCode.currency}})
            .map({$0.map({($0.amount + $0.fee) * ($0.isCredit ? 1 : -1)}).reduce(0, +)})
    }
    
    private func back() -> Observable<Void> {
        return self.actions.back()
    }
    
    private func showSuccess(transaction: Transaction, reload: PublishSubject<Void>) -> Observable<Void> {
        return self.actions.showSuccess(transaction, reload)
    }
    
    private func showError() -> Observable<Void> {
        return actions.showError()
    }
}

public struct PaymentActions {
    let showError: () -> Observable<Void>
    let showSuccess: (Transaction, PublishSubject<Void>) -> Observable<Void>
    let back: () -> Observable<Void>
}
