//
//  ProfileFlowCoordinator.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//


import UIKit
import RxSwift

public protocol ProfileFlowCoordinatorDependencies  {
    func makeProfileVC(actions: ProfileActions) -> ProfileViewController
}

public final class ProfileFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private weak var rootNavVC: UINavigationController?
    private let dependencies: ProfileFlowCoordinatorDependencies
    private weak var vc: UIViewController!
    
    public init(navigationController: UINavigationController?, rootNavVC: UINavigationController?,
         dependencies: ProfileFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.rootNavVC = rootNavVC
        self.dependencies = dependencies
    }
    
    public func start() {
        let actions = ProfileActions(showLogin: self.showLogin, showLogoutAlert: self.showLogoutAlert)
        let vc = dependencies.makeProfileVC(actions: actions)
        self.vc = vc
        navigationController?.pushViewController(self.vc, animated: false)
    }
    
    private func showLogin() -> Observable<Void> {
        self.rootNavVC?.popToRootViewController(animated: true)
        return rootNavVC?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func showLogoutAlert() -> Observable<Int> {
        return UIAlertController.present(in: self.vc, title: Constants.Profile.logoutAlertTitle, message: nil, style: .actionSheet, actions: [UIAlertController.Action(title: Constants.Profile.cancel, style: UIAlertAction.Style.cancel, value: 0), UIAlertController.Action(title: Constants.Profile.confirm, style: UIAlertAction.Style.default, value: 1)])
    }
}
