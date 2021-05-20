//
//  PaymentViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit
import RxSwift

public class PaymentViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var namePayLabel: OCLabel!
    @IBOutlet weak var walletLabel: OCLabel!
    @IBOutlet weak var totalAmountTextLabel: OCLabel!
    @IBOutlet weak var amountLabel: OCLabel!
    @IBOutlet weak var nextIcon: UIImageView!
    @IBOutlet weak var subtotalTextLabel: OCLabel!
    @IBOutlet weak var subTotalLabel: OCLabel!
    @IBOutlet weak var feeTextLabel: OCLabel!
    @IBOutlet weak var feeLabel: OCLabel!
    @IBOutlet weak var defaultPaymentTextLabel: OCLabel!
    @IBOutlet weak var availableTextLabel: OCLabel!
    @IBOutlet weak var fasterPayTextLabel: OCLabel!
    @IBOutlet weak var balanceTextLabel: OCLabel!
    @IBOutlet weak var fasterPayCurrencyLabel: OCLabel!
    @IBOutlet weak var changeLabel: OCLabel!
    @IBOutlet weak var payButton: SubmitButton!
    
    
    private var viewModel: PaymentVM!
    private let disposeBag = DisposeBag()
    private let didLoad = PublishSubject<Void>()
    
    static func create(with viewModel: PaymentVM) -> PaymentViewController {
        let vc = PaymentViewController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    private func setupUI() {
        self.setupNaviBar()
        /// UILabel
        [self.totalAmountTextLabel, self.subtotalTextLabel, self.feeTextLabel, self.defaultPaymentTextLabel, self.availableTextLabel].forEach({ $0?.textColor = Colors.slateGray })
        self.changeLabel.textColor = Colors.curiousBlue
        
        [self.namePayLabel, self.walletLabel, self.amountLabel, self.fasterPayCurrencyLabel, self.fasterPayTextLabel, self.balanceTextLabel].forEach({ $0?.textColor = Colors.black })
        
        self.payButton.cornerRadius = self.payButton.frame.height / 2
        self.payButton.textColor = Colors.black
        self.payButton.backgroundColor = Colors.lightningYellow
        
        self.topView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    private func bind() {
        let input = PaymentVM.Input(didClickBack: (self.navigationItem.leftBarButtonItem!.customView as! UIButton).rx.tap.asObservable(), didLoad: self.didLoad.asObservable(), makePayment: self.payButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        output.amount
            .bind(to: self.subTotalLabel.rx.text)
            .disposed(by: disposeBag)
        output.companyName
            .bind(to: self.namePayLabel.rx.text)
            .disposed(by: disposeBag)
        output.fee
            .bind(to: self.feeLabel.rx.text)
            .disposed(by: disposeBag)
        output.totalBalance
            .bind(to: self.fasterPayCurrencyLabel.rx.text)
            .disposed(by: disposeBag)
        output.totalMoney
            .bind(to: self.payButton.rx.text)
            .disposed(by: disposeBag)
        output.totalMoney
            .bind(to: self.amountLabel.rx.text)
            .disposed(by: disposeBag)

        output.didBack
            .subscribe{_ in}
            .disposed(by: disposeBag)

        output.didShowPopup
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        output.didShowError
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        didLoad.onNext(())
    }
}


//MARK: Supporting function
extension PaymentViewController {
    private func setupNaviBar() {
        /// Add back button
        let button = UIButton(type: .custom)
        button.setImage(Images.icBack, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        /// Add title label
        let titleLabel = UILabel()
        titleLabel.font = Fonts.semiBold(with: 28)
        titleLabel.textColor = Colors.white
        titleLabel.text = Constants.Payment.navTitle
        self.navigationItem.titleView = titleLabel
        
        /// Set clear background navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
}
