//
//  AuthenFlowCoordinator.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit
import RxSwift

protocol AuthenFlowCoordinatorDependencies  {
    func makeLoginViewController(actions: LoginActions) -> LoginViewController
    func makeSignupViewController(actions: SignupActions) -> SignupViewController
    func makeDashboardFlowCoordinator(navigationController: UINavigationController?, user: User) -> DashboardFlowCoordinator
}

final class AuthenFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: AuthenFlowCoordinatorDependencies

    private weak var loginVC: LoginViewController?

    init(navigationController: UINavigationController,
         dependencies: AuthenFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    func start() {
        let actions = LoginActions(showDashboard: self.showDashboard, showSignup: self.showSignup, showAlert: self.showAlert)
        let vc = dependencies.makeLoginViewController(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
        loginVC = vc
    }
    
    func showSignup() -> Observable<Void> {
        let vc = dependencies.makeSignupViewController(actions: SignupActions(showLogin: self.showLogin, showDashboard: self.showDashboard, showAlert: self.showAlert, showAlertError: self.showAlertError))
        navigationController?.pushViewController(vc, animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    func showLogin() -> Observable<Void> {
        self.navigationController?.popToRootViewController(animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    func showDashboard(user: User) -> Observable<Void> {
        let flow = dependencies.makeDashboardFlowCoordinator(navigationController: navigationController, user: user)
        return flow.start()
    }
    
    func showAlert() -> Observable<Void> {
        return UIAlertController.present(in: self.loginVC!, title: Constants.SignIn.loginFailed, message: Constants.SignIn.loginFailedMessage, style: .alert, actions: [UIAlertController.Action(title: Constants.Profile.cancel, style: UIAlertAction.Style.cancel, value: 0)]).mapToVoid()
    }
    
    func showAlertError(text: String?) -> Observable<Void> {
        return UIAlertController.present(in: self.loginVC!, title: Constants.SignIn.loginFailed, message: text, style: .alert, actions: [UIAlertController.Action(title: Constants.Profile.cancel, style: UIAlertAction.Style.cancel, value: 0)]).mapToVoid()
    }
}
