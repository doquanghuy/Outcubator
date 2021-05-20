//
//  TransactionPopup.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit
import RxSwift

public class TransactionPopup: UIViewController {
    private let disposeBag = DisposeBag()
    private var viewModel: TransactionVM!
    private let didLoad = PublishSubject<Void>()
    private let willAppear = PublishSubject<Void>()

    static func create(viewModel: TransactionVM) -> TransactionPopup {
        let vc = TransactionPopup.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    @IBOutlet weak var topBackgroudImage: UIImageView!
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var successIcon: UIImageView!
    @IBOutlet weak var transactionSuccesTextLabel: UILabel!
    @IBOutlet weak var codeTextLabel: UILabel!
    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.3) {
            self.showPopup()
        }
    }
    
    private func setupUI() {
        self.popupView.addShadow()
        self.popupView.layer.cornerRadius = 20
        self.popupView.layer.masksToBounds = true
        self.popupView.clipsToBounds = true
        
        ///UILabel
        self.transactionSuccesTextLabel.text = Constants.TrasactionPopup.title
        self.codeTextLabel.text = Constants.TrasactionPopup.transactionCode
        self.infoLabel.text = Constants.TrasactionPopup.info
        
        [self.transactionSuccesTextLabel, self.codeTextLabel, self.infoLabel].forEach( {$0?.textColor = Colors.black})
        
        /// UIImageView
        self.successIcon.image = Images.icSuccess
        self.successIcon.backgroundColor = Colors.panacheapprox
        self.successIcon.roundCorners(.allCorners, radius: self.successIcon.bounds.height/2)
        self.topBackgroudImage.image = Images.imgTransactionPopup
        
        /// UIButton
        self.okButton.setTitle(Constants.TrasactionPopup.ok, for: .normal)
        self.okButton.titleLabel?.textColor = Colors.curiousBlue
    }
    
    private func bind() {
        let input = TransactionVM.Input(didload: self.didLoad.asObservable(), didClickClose: okButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input: input)
        output.didClose
            .subscribe()
            .disposed(by: disposeBag)
        
        output.transactionCode
            .bind(to: self.codeLabel.rx.text)
            .disposed(by: disposeBag)
        
        didLoad.onNext(())
    }
}

extension TransactionPopup {
    private func hidePopup() {
        self.popupView.alpha = 0.0
        self.view.backgroundColor = Colors.black.withAlphaComponent(0.0)
        self.popupView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    private func showPopup() {
        self.popupView.alpha = 1.0
        self.view.backgroundColor = Colors.black.withAlphaComponent(0.5)
        self.popupView.transform = .identity
    }
}
