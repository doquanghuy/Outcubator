//
//  DashboardDIContainer.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit

public final class DashboardDIContainer {
    struct Dependencies {
        let user: User
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func makeTabBarVM(actions: TabBarListActions, user: User) -> TabBarVM {
        return TabBarVM(actions: actions, user: user)
    }
    
    public func makeTabBarVC(actions: TabBarListActions) -> UITabBarController {
        return CustomTabBarViewController.create(with: makeTabBarVM(actions: actions, user: self.dependencies.user))
    }
    
    
    func makeWalletDIContainer(user: User) -> WalletDIContainer {
        return WalletDIContainer(dependencies: WalletDIContainer.Dependencies(user: user))
    }
    
    func makeScanDIContainer(user: User) -> ScanDIContainer {
        return ScanDIContainer(dependencies: ScanDIContainer.Dependencies(user: user))

    }
    
    func makeProfileDIContainer(user: User) -> ProfileDIContainer {
        return ProfileDIContainer(dependencies: ProfileDIContainer.Dependencies(user: user))

    }
    
    public func makeWalletFlowCoordinator(navigationController: UINavigationController?) -> WalletFlowCoordinator {
        return WalletFlowCoordinator(navigationController: navigationController, dependencies: makeWalletDIContainer(user: self.dependencies.user))
    }
    
    public func makeScanFlowCoordinator(navigationController: UINavigationController?) -> ScanFlowCoordinator {
        return ScanFlowCoordinator(navigationController: navigationController, dependencies: makeScanDIContainer(user: self.dependencies.user))
    }
    
    public func makeProfileFlowCoordinator(navigationController: UINavigationController?, rootNavVC: UINavigationController?) -> ProfileFlowCoordinator {
        return ProfileFlowCoordinator(navigationController: navigationController, rootNavVC: rootNavVC, dependencies: makeProfileDIContainer(user: self.dependencies.user))
    }
    
    func makeDashboardFlowCoordinator(navigationController: UINavigationController?) -> DashboardFlowCoordinator {
        return DashboardFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
}

extension DashboardDIContainer: DashboardFlowCoordinatorDependencies {}
