//
//  SignupViewModel.swift
//  Outcubator
//
//  Created by doquanghuy on 12/05/2021.
//

import UIKit
import RxSwift

protocol SignupViewModelInput {
    var didChangeEmail: Observable<String?> {get}
    var didChangePassword: Observable<String?> {get}
    var didChangeFirstName: Observable<String?> {get}
    var didChangeLastName: Observable<String?> {get}
    var didClickLogin: Observable<Void> {get}
    var didClickSignup: Observable<Void> {get}
    var didClickConfirm: Observable<Bool> {get}
}

protocol SignupViewModelOutput {
    var isNavigationBarHidden: Observable<Bool> {get}
    var loginText: Observable<String> {get}
    var signupText: Observable<String> {get}
    var loginColor: Observable<UIColor> {get}
    var signupColor: Observable<UIColor> {get}
    
    var showError: Observable<Void> {get}
    var didShowDashboard: Observable<Void> {get}
    var didShowSignupError: Observable<Void> {get}
    var didShowLogin: Observable<Void> {get}
    var didCreateTransactions: Observable<Void> {get}
}

protocol SignupViewModelInterface {
    func transform(input: SignupViewModelInput) -> SignupViewModelOutput
}

fileprivate enum SignupError {
    case none, email, password, firstname, lastname, confirm
    func asString() -> String? {
        switch self {
        case .email:
            return Constants.SignUp.emailError
        case .firstname:
            return Constants.SignUp.firstNameError
        case .lastname:
            return Constants.SignUp.lastNameError
        case .confirm:
            return Constants.SignUp.confirmError
        case .password:
            return Constants.SignUp.passwordError
        default:
            return nil
        }
    }
}


fileprivate struct SignupInfo {
    let email: String?
    let password: String?
    let firstName: String?
    let lastName: String?
    let confirmed: Bool
    
    func asError() -> SignupError {
        if email?.isValidEmail ?? false == false {
            return .email
        }
        if password?.isEmpty ?? true == true {
            return .password
        }
        if firstName?.isEmpty ?? true == true {
            return .firstname
        }
        if lastName?.isEmpty ?? true == true {
            return .lastname
        }
        if confirmed == false {
            return .confirm
        }
        return .none
    }
}

final class SignupViewModel: SignupViewModelInterface {
    //MARK: Input
    struct Input: SignupViewModelInput {
        var didChangeEmail: Observable<String?>
        var didChangePassword: Observable<String?>
        var didChangeFirstName: Observable<String?>
        var didChangeLastName: Observable<String?>
        var didClickLogin: Observable<Void>
        var didClickSignup: Observable<Void>
        var didClickConfirm: Observable<Bool>
    }
    
    //MARK: Output
    struct Output: SignupViewModelOutput {
        var isNavigationBarHidden: Observable<Bool>
        var loginText: Observable<String>
        var signupText: Observable<String>
        var loginColor: Observable<UIColor>
        var signupColor: Observable<UIColor>
        
        var showError: Observable<Void>
        var didShowDashboard: Observable<Void>
        var didShowSignupError: Observable<Void>
        var didShowLogin: Observable<Void>
        var didCreateTransactions: Observable<Void>
    }
    
    private let signupUseCases: SignupUseCases
    private let actions: SignupActions
    
    init(useCases: SignupUseCases, actions: SignupActions) {
        self.signupUseCases = useCases
        self.actions = actions
    }
    
    func transform(input: SignupViewModelInput) -> SignupViewModelOutput {
        let isNavigationBarHidden = Observable.just(true)
        let loginText = Observable.just(Constants.SignIn.login)
        let signupText = Observable.just(Constants.SignIn.signup)
        let loginColor = Observable.just(Colors.rum)
        let signupColor = Observable.just(Colors.lightningYellow)
        
        let credentials = Observable
            .combineLatest(input.didChangeEmail, input.didChangePassword, input.didChangeFirstName, input.didChangeLastName, input.didClickConfirm)
            .map({SignupInfo(email: $0, password: $1, firstName: $2, lastName: $3, confirmed: $4)})
        let didClickSignup = input.didClickSignup
            .withLatestFrom(credentials)
        
        let showError = didClickSignup
            .map({$0.asError()})
            .filter({$0 != .none})
            .map({$0.asString()!})
            .flatMap({text in self.showAlertError(text: text)})
        
        let didSignup = didClickSignup
            .filter({$0.asError() == .none})
            .flatMap({self.signup(email: $0.email, password: $0.password, firstName: $0.firstName, lastName: $0.lastName)})
            .share()

        let didShowSignupError = didSignup
            .filter({$0 == nil})
            .flatMap({_ in self.showAlert()})
        
        let didShowLogin = input.didClickLogin
            .flatMap({self.showLogin()})
        
        let didCreateTransactions = didSignup
            .filter({$0 != nil})
            .flatMap({self.createSomeRandomTransactions(user: $0)})
            .share()
        
        let didShowDashboard = didCreateTransactions
            .flatMap({self.showDashboard(user: $0!)})
                
        return Output(isNavigationBarHidden: isNavigationBarHidden, loginText: loginText, signupText: signupText, loginColor: loginColor, signupColor: signupColor, showError: showError, didShowDashboard: didShowDashboard, didShowSignupError: didShowSignupError, didShowLogin: didShowLogin, didCreateTransactions: didCreateTransactions.mapToVoid())
    }
    
    private func signup(email: String?, password: String?, firstName: String?, lastName: String?) -> Observable<User?> {
        return Observable.deferred {
            guard let email = email, let password = password, let firstName = firstName, let lastName = lastName else {
                return Observable.just(nil)
            }
            return self.signupUseCases
                .execute(query: SignupQuery(email: email, password: password, firstName: firstName, lastName: lastName))
                .map({User(domain: $0)})
        }
    }
    
    private func createSomeRandomTransactions(user: User?) -> Observable<User?> {
        let numberTransactions = Int.random(in: 10...15)
        let transactions = (1...numberTransactions)
            .map {_ in
                self.signupUseCases.save(transaction: Transaction(uid: UUID().uuidString, companyName: Transaction.companyName, currency: Transaction.currency, amount: Transaction.amount, fee: Transaction.fee, createdTime: Date().timeIntervalSince1970, isCredit: Transaction.isCredit, userId: user?.uid ?? "").asDomain()).map({_ in user})
            }
        return Observable.merge(transactions)
    }
    
    private func showDashboard(user: User) -> Observable<Void> {
        return self.actions.showDashboard(user)
    }
    
    private func showAlert() -> Observable<Void> {
        return self.actions.showAlert()
    }
    
    private func showLogin() -> Observable<Void> {
        return self.actions.showLogin()
    }
    
    private func showAlertError(text: String?) -> Observable<Void> {
        return self.actions.showAlertError(text)
    }
}

public struct SignupActions {
    let showLogin: () -> Observable<Void>
    let showDashboard: (User) -> Observable<Void>
    let showAlert: () -> Observable<Void>
    let showAlertError: (String?) -> Observable<Void>
}
