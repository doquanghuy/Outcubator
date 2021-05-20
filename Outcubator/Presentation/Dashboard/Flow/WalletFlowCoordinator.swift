//
//  WalletFlowCoordinator.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit
import RxSwift

public protocol WalletFlowCoordinatorDependencies  {
    func makeWalletVC(actions: WalletActions) -> WalletViewController
    func makeCurrenciesVC(actions: CurrenciesActions, reload: PublishSubject<String>) -> CurrenciesViewController
}

public final class WalletFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: WalletFlowCoordinatorDependencies

    public init(navigationController: UINavigationController?,
         dependencies: WalletFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        let actions = WalletActions(showCurrencies: self.showCurrencies)
        let vc = dependencies.makeWalletVC(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showCurrencies(reloadAction: PublishSubject<String>) -> Observable<Void> {
        let actions = CurrenciesActions(select: self.select(currency:), back: self.back)
        let currencyVC = dependencies.makeCurrenciesVC(actions: actions, reload: reloadAction)
        navigationController?.pushViewController(currencyVC, animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func select(currency: String) -> Observable<Void> {
        navigationController?.popViewController(animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func back() -> Observable<Void> {
        navigationController?.popViewController(animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
}
