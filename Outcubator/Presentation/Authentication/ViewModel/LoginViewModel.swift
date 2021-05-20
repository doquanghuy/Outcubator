//
//  LoginViewModel.swift
//  Outcubator
//
//  Created by doquanghuy on 12/05/2021.
//

import RxSwift
import RxCocoa

protocol LoginViewModelInput {
    var didChangeEmail: Observable<String?> {get}
    var didChangePassword: Observable<String?> {get}
    var didClickLogin: Observable<Void> {get}
    var didClickSignup: Observable<Void> {get}
    var viewDidLoad: Observable<Void> {get}
}

protocol LoginViewModelOutput {
    var email: Observable<String?> {get}
    var password: Observable<String?> {get}
    var showError: Observable<Void> {get}
    var didShowDashboard: Observable<Void> {get}
    var didShowLoginError: Observable<Void> {get}
    var didShowSignup: Observable<Void> {get}
}

protocol LoginViewModelInterface {
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput
}

final class LoginViewModel: LoginViewModelInterface {
    private let loginUseCases: LoginUseCases
    private let actions: LoginActions
    private let disposeBag = DisposeBag()
    
    //MARK: Input
    struct Input: LoginViewModelInput {
        var viewDidLoad: Observable<Void>
        var didChangeEmail: Observable<String?>
        var didChangePassword: Observable<String?>
        var didClickLogin: Observable<Void>
        var didClickSignup: Observable<Void>
    }
    
    //MARK: Output
    struct Output: LoginViewModelOutput {
        var showError: Observable<Void>
        var didShowDashboard: Observable<Void>
        var didShowLoginError: Observable<Void>
        var didShowSignup: Observable<Void>
        
        var email: Observable<String?>
        var password: Observable<String?>
    }
    
    init(useCases: LoginUseCases, actions: LoginActions) {
        self.loginUseCases = useCases
        self.actions = actions
    }
        
    func transform(input: LoginViewModelInput) -> LoginViewModelOutput {
        let isNavigationBarHidden = Observable.just(true)
        let loginText = Observable.just(Constants.SignIn.login)
        let signupText = Observable.just(Constants.SignIn.signup)
        let loginColor = Observable.just(Colors.lightningYellow)
        let signupColor = Observable.just(Colors.rum)
        
        let credentials = Observable
            .combineLatest(input.didChangeEmail, input.didChangePassword)
       
        input.didChangeEmail.subscribe {data in
            print(data)
        }
        .disposed(by: disposeBag)
        let didClickLogin = input.didClickLogin
            .withLatestFrom(credentials)
      
        let showError = didClickLogin
            .filter({!($0.0?.isValidEmail ?? false) && ($0.1?.isEmpty ?? true)})
            .flatMap({_ in self.showAlert()})
        let didLogin = didClickLogin
            .filter({$0.0?.isValidEmail ?? false && !($0.1?.isEmpty ?? true)})
            .flatMap({self.login(email: $0, password: $1)})
        let didShowDashboard = didLogin
            .filter({$0 != nil})
            .flatMap({self.showDashboard(user: $0!)})
        let didShowLoginError = didLogin
            .filter({$0 == nil})
            .flatMap({_ in self.showAlert()})
        
        let didShowSignup = input.didClickSignup
            .flatMap({
                self.showSignup()
            })
        
        let didLoad = input.viewDidLoad
            .flatMap({self.load()})
            .share()
        let email = didLoad
            .map({$0.userName})
        let password = didLoad
            .map({$0.password})
        
        return Output(showError: showError, didShowDashboard: didShowDashboard, didShowLoginError: didShowLoginError, didShowSignup: didShowSignup, email: email, password: password)
    }
    
    private func login(email: String?, password: String?) -> Observable<User?> {
        guard let email = email, let password = password else {
            return Observable.just(nil)
        }
        return self.loginUseCases
            .execute(query: LoginQuery(email: email, password: password))
            .map({User(domain: $0)})
    }
    
    private func load() -> Observable<(userName: String?, password: String?)> {
        return self.loginUseCases.load()
    }
    
    private func showDashboard(user: User) -> Observable<Void> {
        return self.actions.showDashboard(user)
    }
    
    private func showAlert() -> Observable<Void> {
        return self.actions.showAlert()
    }
    
    private func showSignup() -> Observable<Void> {
        return self.actions.showSignup()
    }
}

public struct LoginActions {
    let showDashboard: (User) -> Observable<Void>
    let showSignup: () -> Observable<Void>
    let showAlert: () -> Observable<Void>
}
