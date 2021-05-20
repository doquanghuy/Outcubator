//
//  SignupViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 12/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class SignupViewController: UIViewController {
    
    @IBOutlet weak var passportIcon: UIImageView!
    @IBOutlet weak var passportLabel: OCLabel!
    @IBOutlet weak var createToLabel: OCLabel!
    @IBOutlet weak var toUseLabel: OCLabel!
    @IBOutlet weak var fasterPayIcon: UIImageView!
    @IBOutlet weak var fasterPayLabel: OCLabel!
    @IBOutlet weak var emailTextField: OCTextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var passwordHintLabel: OCLabel!
    @IBOutlet weak var firstNameTextField: OCTextField!
    @IBOutlet weak var lastNameTextField: OCTextField!
    @IBOutlet weak var signupButton: SubmitButton!
    @IBOutlet weak var loginButton: SubmitButton!
    @IBOutlet weak var switchView: UISwitch!
    @IBOutlet weak var policyFirstLabel: OCLabel!
    @IBOutlet weak var policySecondLabel: OCLabel!
    
    private let disposeBag = DisposeBag()
    private var viewModel: SignupViewModel!
    
    static func create(with viewModel: SignupViewModel) -> SignupViewController {
        let vc = SignupViewController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func setupUI() {
        // UILabale
        self.passportLabel.text = Constants.Profile.passport
        self.passportLabel.font = Fonts.bold(with: self.passportLabel.textSize)
        
        self.createToLabel.text = Constants.SignUp.createAccount
        self.toUseLabel.text = Constants.SignUp.toUse
        
        self.fasterPayLabel.text = Constants.Profile.fasterPay
        self.fasterPayLabel.font = Fonts.bold(with: self.fasterPayLabel.textSize)
        
        self.passwordHintLabel.text = Constants.SignUp.hintPassword
        self.passwordHintLabel.textColor = Colors.rum
        
        self.policyFirstLabel.text = Constants.SignUp.policyFirst
        self.policySecondLabel.text = Constants.SignUp.policySecond
        
        //UIImageView
        self.passportIcon.image = Images.icPassport
        self.fasterPayIcon.image = Images.icFasterPay
        
        //UITextField
        self.emailTextField.placeholder = Constants.SignUp.email
        self.emailTextField.configUI()
        self.emailTextField.keyboardType = .emailAddress
        
        self.passwordTextField.placeholder = Constants.SignUp.createPassword
        self.passwordTextField.configUI()
        self.passwordTextField.isSecureTextEntry = true
        
        self.firstNameTextField.placeholder = Constants.SignUp.firstName
        self.firstNameTextField.configUI()
        
        self.lastNameTextField.placeholder = Constants.SignUp.firstName
        self.lastNameTextField.configUI()
        
        //UIButton
        self.loginButton.cornerRadius = self.loginButton.frame.height / 2
        self.loginButton.textColor = Colors.white
        self.loginButton.backgroundColor = Colors.lightningYellow
        
        self.signupButton.cornerRadius = self.signupButton.frame.height / 2
        self.signupButton.textColor = Colors.black
        self.signupButton.backgroundColor = Colors.rum
    }
    
    private func bind() {
        let input = SignupViewModel.Input(didChangeEmail: emailTextField.rx.text.asObservable(), didChangePassword: passwordTextField.rx.text.asObservable(), didChangeFirstName: firstNameTextField.rx.text.asObservable(), didChangeLastName: lastNameTextField.rx.text.asObservable(), didClickLogin: self.loginButton.rx.tap.asObservable(), didClickSignup: self.signupButton.rx.tap.asObservable(), didClickConfirm: self.switchView.rx.isOn.asObservable())
        let output = self.viewModel.transform(input: input)
        output.isNavigationBarHidden
            .bind(to: self.navigationController!.rx.isNavigationBarHidden)
            .disposed(by: disposeBag)
        output.loginColor
            .subscribe {(color) in
                self.loginButton.bgColor = color
            }
            .disposed(by: disposeBag)
        output.signupColor
            .subscribe {(color) in
                self.signupButton.bgColor = color
            }
            .disposed(by: disposeBag)
        output.loginText
            .subscribe {(text) in
                self.loginButton.text = text
            }
            .disposed(by: disposeBag)
        output.signupText
            .subscribe {(text) in
                self.signupButton.text = text
            }
            .disposed(by: disposeBag)
        
        output.didShowLogin
            .subscribe()
            .disposed(by: disposeBag)
        
        output.didShowDashboard
            .subscribe()
            .disposed(by: disposeBag)
        
        output.didShowSignupError
            .subscribe()
            .disposed(by: disposeBag)
        
        output.didCreateTransactions
            .subscribe()
            .disposed(by: disposeBag)
        
        output.showError
            .subscribe()
            .disposed(by: disposeBag)
    }
}
