//
//  AuthenDIContainer.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit

final class AuthenDIContainer {
    struct Dependencies {
        
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeLoginUseCases() -> LoginUseCases {
        return LoginUseCasesPlatform(repository: makeUserRepository(), local: makeLocalRepository())
    }
    
    func makeSignupUseCases() -> SignupUseCases {
        return  SignupUseCasesPlatform(userRepo: makeUserRepository(), transRepo: makeTransactionRepository(), local: makeLocalRepository())
    }
    
    // MARK: - Repositories
    func makeUserRepository() -> DefaultRemoteRepository<UserDomain> {
        return DefaultRemoteRepository(configuration: .defaultConfiguration)
    }
    
    func makeTransactionRepository() -> DefaultRemoteRepository<TransactionDomain> {
        return DefaultRemoteRepository(configuration: .defaultConfiguration)
    }
    
    func makeLocalRepository() -> DefaultLocalRepository<UserDomain> {
        return DefaultLocalRepository()
    }
    
    // MARK: - Authen
    func makeLoginViewController(actions: LoginActions) -> LoginViewController {
        return LoginViewController.create(with: makeLoginViewModel(actions: actions))
    }
    
    func makeLoginViewModel(actions: LoginActions) -> LoginViewModel {
        return LoginViewModel(useCases: makeLoginUseCases(), actions: actions)
    }
    
    func makeSignupViewModel(actions: SignupActions) -> SignupViewModel {
        return SignupViewModel(useCases: makeSignupUseCases(), actions: actions)
    }
    
    func makeSignupViewController(actions: SignupActions) -> SignupViewController {
        return SignupViewController.create(with: makeSignupViewModel(actions: actions))
    }
    
    // MARK: - Flow Coordinators
    func makeAuthenFlowCoordinator(navigationController: UINavigationController) -> AuthenFlowCoordinator {
        return AuthenFlowCoordinator(navigationController: navigationController, dependencies: self)
    }
    
    func makeDashboardDIContainer(user: User) -> DashboardDIContainer {
        return DashboardDIContainer(dependencies: DashboardDIContainer.Dependencies(user: user))
    }
    
    func makeDashboardFlowCoordinator(navigationController: UINavigationController?, user: User) -> DashboardFlowCoordinator {
        return DashboardFlowCoordinator(navigationController: navigationController, dependencies: makeDashboardDIContainer(user: user))
    }
}

extension AuthenDIContainer: AuthenFlowCoordinatorDependencies {}
