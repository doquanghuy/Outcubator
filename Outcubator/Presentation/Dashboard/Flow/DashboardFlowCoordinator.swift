//
//  DashboardFlowCoordinator.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

public protocol DashboardFlowCoordinatorDependencies  {
    func makeTabBarVC(actions: TabBarListActions) -> UITabBarController
    func makeWalletFlowCoordinator(navigationController: UINavigationController?) -> WalletFlowCoordinator
    func makeScanFlowCoordinator(navigationController: UINavigationController?) -> ScanFlowCoordinator
    func makeProfileFlowCoordinator(navigationController: UINavigationController?, rootNavVC: UINavigationController?) -> ProfileFlowCoordinator
}

public final class DashboardFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: DashboardFlowCoordinatorDependencies

    private weak var tabbarVC: UITabBarController?

    public init(navigationController: UINavigationController?,
         dependencies: DashboardFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() -> Observable<Void> {
        let actions = TabBarListActions(showWallet: self.showWallet, showScan: self.showScan, showProfile: self.showProfile)
        let vc = dependencies.makeTabBarVC(actions: actions)
        let vc1 = CustomNavigationController()
        let vc2 = CustomNavigationController()
        let vc3 = CustomNavigationController()
        vc1.tabBarItem = UITabBarItem(title: Constants.Tabbar.wallet,
                                      image: Images.icWallet,
                                      selectedImage: Images.icWallet)
        vc2.tabBarItem = UITabBarItem(title: Constants.Tabbar.scan,
                                      image: Images.icScan,
                                      selectedImage: Images.icScan)
        vc3.tabBarItem = UITabBarItem(title: Constants.Tabbar.profile,
                                      image: Images.icProfile,
                                      selectedImage: Images.icProfile)

        vc.viewControllers = [vc1, vc2, vc3]
        tabbarVC = vc
        navigationController?.pushViewController(vc, animated: false)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    func showWallet(user: User) {
        guard let nav = tabbarVC?.viewControllers?.first as? UINavigationController else {return}
        let flow = dependencies.makeWalletFlowCoordinator(navigationController: nav)
        flow.start()
    }
    
    func showScan() {
        guard let nav = tabbarVC?.viewControllers?[1] as? UINavigationController else {return}
        let flow = dependencies.makeScanFlowCoordinator(navigationController: nav)
        flow.start()
    }
    
    func showProfile() {
        guard let nav = tabbarVC?.viewControllers?[2] as? UINavigationController else {return}
        let flow = dependencies.makeProfileFlowCoordinator(navigationController: nav, rootNavVC: self.navigationController)
        flow.start()
    }
}
