//
//  CurrenciesViewModel.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation
import RxSwift
import RxDataSources

protocol CurrenciesVMInput {
    var didLoad: Observable<Void> {get}
    var didClickBack: Observable<Void> {get}
    var didSelectCurrency: Observable<Int> {get}
}

protocol CurrenciesVMOutput {
    var didLoadCurrencies: Observable<[CurrenciesSectionModel]> {get}
    var didBack: Observable<Void> {get}
    var didSelect: Observable<Void> {get}
}

protocol CurrenciesVMInterface {
    func transform(input: CurrenciesVMInput) -> CurrenciesVMOutput
}

final class CurrenciesVM: CurrenciesVMInterface {
    struct Input: CurrenciesVMInput {
        var didLoad: Observable<Void>
        var didClickBack: Observable<Void>
        var didSelectCurrency: Observable<Int>
    }
    
    struct Output: CurrenciesVMOutput {
        var didLoadCurrencies: Observable<[CurrenciesSectionModel]>
        var didBack: Observable<Void>
        var didSelect: Observable<Void>
    }
    
    private let user: User
    private let walletUseCases: WalletUseCases
    private let actions: CurrenciesActions
    private let reload: PublishSubject<String>
    
    init(user: User, walletUseCases: WalletUseCases, actions: CurrenciesActions, reload: PublishSubject<String>) {
        self.user = user
        self.walletUseCases = walletUseCases
        self.actions = actions
        self.reload = reload
    }
    
    func transform(input: CurrenciesVMInput) -> CurrenciesVMOutput {
        let didLoadCurrencies = input
            .didLoad
            .flatMap({self.loadCurrencies(user: self.user)})
            .map({[CurrenciesSectionModel(header: "", items: $0)]})
            .share()
        let didBack = input.didClickBack
            .flatMap({self.back()})
        
        let didSelect = input.didSelectCurrency
            .withLatestFrom(didLoadCurrencies) {$1.first!.items[$0]}
            .flatMap({self.select(currency: $0)})
        
        return Output(didLoadCurrencies: didLoadCurrencies, didBack: didBack, didSelect: didSelect)
    }
    
    private func back() -> Observable<Void> {
        return self.actions.back()
    }
    
    private func select(currency: String) -> Observable<Void> {
        reload.onNext(currency)
        return self.actions.select(currency)
    }
    
    private func loadCurrencies(user: User) -> Observable<[String]> {
        return self.walletUseCases.loadCurrencies(user: user.asDomain())
    }
}

public struct CurrenciesActions {
    let select: (String) -> Observable<Void>
    let back: () -> Observable<Void>
}
