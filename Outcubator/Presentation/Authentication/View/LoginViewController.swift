//
//  LoginViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 12/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    @IBOutlet weak var fasterPayImage: UIImageView!
    @IBOutlet weak var fasterPayLabel: OCLabel!
    @IBOutlet weak var signInLabel: OCLabel!
    @IBOutlet weak var useYourLabel: OCLabel!
    @IBOutlet weak var passportIcon: UIImageView!
    @IBOutlet weak var passportLabel: OCLabel!
    @IBOutlet weak var accountLabel: OCLabel!
    @IBOutlet weak var touchIdButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: OCButton!
    @IBOutlet weak var emailTextField: OCTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var loginButton: SubmitButton!
    @IBOutlet weak var signupButton: SubmitButton!
    
    private let didLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var viewModel: LoginViewModel!
    
    static func create(with viewModel: LoginViewModel) -> LoginViewController {
        let vc = LoginViewController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enableKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disableKeyboard()
    }
    
    private func setupUI() {
        //UINavigation Controller
        self.navigationController?.isNavigationBarHidden = true

        // UIlabel
        self.fasterPayLabel.text = Constants.Profile.fasterPay
        self.fasterPayLabel.font = Fonts.bold(with: self.fasterPayLabel.textSize)
        
        self.signInLabel.text = Constants.SignIn.signIn
        self.signInLabel.font = Fonts.bold(with: self.signInLabel.textSize)
        
        self.useYourLabel.text = Constants.SignIn.useYour
        
        self.passportLabel.text = Constants.Profile.passport
        self.passportLabel.font = Fonts.bold(with: self.passportLabel.textSize)
        
        self.accountLabel.text = Constants.SignIn.account
        
        [self.fasterPayLabel, self.signInLabel, self.useYourLabel, self.passportLabel, self.accountLabel].forEach({ $0?.textColor = Colors.white })
        
        // UIImageView
        self.fasterPayImage.image = Images.icFasterPay
        self.passportIcon.image = Images.icPassport
        
        // UITextfield
        self.emailTextField.placeholder = Constants.SignIn.email
        self.emailTextField.configUI()
        self.emailTextField.keyboardType = .emailAddress
        
        self.passwordTextField.placeholder = Constants.SignIn.password
        self.passwordTextField.configUI()
        self.passwordTextField.isSecureTextEntry = true
        // UIButton
        self.touchIdButton.setImage(Images.icTouchId, for: .normal)
        
        self.forgotPasswordButton.setTitle(Constants.SignIn.fotgotPassword, for: .normal)
        self.forgotPasswordButton.setTitleColor(Colors.lightningYellow, for: .normal)
        
        self.loginButton.cornerRadius = self.loginButton.frame.height / 2
        self.loginButton.textColor = Colors.black
        self.loginButton.bgColor = Colors.lightningYellow
        self.loginButton.text = Constants.SignIn.login

        self.signupButton.cornerRadius = self.signupButton.frame.height / 2
        self.signupButton.textColor = Colors.white
        self.signupButton.bgColor = Colors.rum
        self.signupButton.text = Constants.SignIn.signup
    }
    
    private func disableKeyboard() {
        IQKeyboardManager.shared.enable = false
    }
    
    private func enableKeyboard() {
        IQKeyboardManager.shared.enable = true
    }
    
    private func bind() {
        let input = LoginViewModel.Input(viewDidLoad: didLoad.asObservable(), didChangeEmail: self.emailTextField.rx.text.asObservable(), didChangePassword: self.passwordTextField.rx.text.asObservable(), didClickLogin: self.loginButton.rx.tap.asObservable(), didClickSignup: self.signupButton.rx.tap.asObservable())
        let output = self.viewModel.transform(input: input)
        
        output.didShowSignup
            .subscribe({_ in})
            .disposed(by: disposeBag)
        
        output.didShowDashboard
            .subscribe({_ in})
            .disposed(by: disposeBag)
        
        output.didShowLoginError
            .subscribe({_ in})
            .disposed(by: disposeBag)
        
        output.email
            .subscribe(onNext: {text in
                self.emailTextField.text = text
                self.emailTextField.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        output.password
            .subscribe(onNext: {text in
                self.passwordTextField.text = text
                self.passwordTextField.sendActions(for: .valueChanged)
            })
            .disposed(by: disposeBag)
        didLoad.onNext(())
    }
}
