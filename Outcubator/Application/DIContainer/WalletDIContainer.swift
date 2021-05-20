//
//  WalletDIContainer.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit
import RxSwift

final class WalletDIContainer {
    struct Dependencies {
        let user: User
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeRemoteRepository() -> DefaultRemoteRepository<TransactionDomain> {
        return DefaultRemoteRepository(configuration: .defaultConfiguration)
    }
    // MARK: - Use Cases
    func makeWalletUseCase() -> WalletUseCases {
        return WalletUseCasesPlatform(repository: makeRemoteRepository())
    }
    
    func makeWalletViewModel(actions: WalletActions, user: User) -> WalletVM {
        return WalletVM(user: user, walletUseCases: makeWalletUseCase(), actions: actions)
    }
    
    func makeCurrencyViewModel(actions: CurrenciesActions, user: User, reload: PublishSubject<String>) -> CurrenciesVM {
        return CurrenciesVM(user: user, walletUseCases: makeWalletUseCase(), actions: actions, reload: reload)
    }
    
    // MARK: - VC
    public func makeWalletVC(actions: WalletActions) -> WalletViewController {
        return WalletViewController.create(with: makeWalletViewModel(actions: actions, user: self.dependencies.user))
    }
    
    func makeCurrenciesVC(actions: CurrenciesActions, reload: PublishSubject<String>) -> CurrenciesViewController {
        return CurrenciesViewController.create(with: makeCurrencyViewModel(actions: actions, user: self.dependencies.user, reload: reload))
    }
}

extension WalletDIContainer: WalletFlowCoordinatorDependencies {}

