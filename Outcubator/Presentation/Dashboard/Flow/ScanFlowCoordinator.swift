//
//  ScanFlowCoordinator.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit
import RxSwift

public protocol ScanFlowCoordinatorDependencies  {
    func makeScanVC(actions: ScanActions) -> ScanViewController
    func makeTransactionSuccess(actions: TransactionActions, transaction: Transaction) -> TransactionPopup
    func makePaymentVC(actions: PaymentActions, qrCode: QRModel) -> PaymentViewController
}

public final class ScanFlowCoordinator {
    private weak var navigationController: UINavigationController?
    private let dependencies: ScanFlowCoordinatorDependencies
    private weak var paymentVC: UIViewController?

    public init(navigationController: UINavigationController?,
         dependencies: ScanFlowCoordinatorDependencies) {
        self.navigationController = navigationController
        self.dependencies = dependencies
    }
    
    public func start() {
        let actions = ScanActions(showPayment: self.showPayment(qrModel:), showAlert: self.showAlert(qrCase:))
        let vc = dependencies.makeScanVC(actions: actions)
        navigationController?.pushViewController(vc, animated: false)
    }
    
    private func showPayment(qrModel: QRModel) -> Observable<Void> {
        let actions = PaymentActions(showError: self.showError, showSuccess: self.showSuccess, back: self.back)
        let paymentVC = dependencies.makePaymentVC(actions: actions, qrCode: qrModel)
        self.paymentVC = paymentVC
        self.navigationController?.pushViewController(paymentVC, animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func showError() -> Observable<Void> {
        return UIAlertController.present(in: self.paymentVC!, title: Constants.Payment.paymentErrorTitle, message: Constants.Payment.paymentErrorMessage, style: .alert, actions: [UIAlertController.Action(title: Constants.Profile.cancel, style: UIAlertAction.Style.cancel, value: 0)]).mapToVoid()
    }
    
    private func back() -> Observable<Void> {
        self.navigationController?.popViewController(animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func showSuccess(transaction: Transaction) -> Observable<Void> {
        let actions = TransactionActions(close: self.closeTransaction)
        let popup = dependencies.makeTransactionSuccess(actions: actions, transaction: transaction)
        self.navigationController?.pushViewController(popup, animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func closeTransaction() -> Observable<Void> {
        self.navigationController?.popViewController(animated: true)
        return navigationController?.rx.delegate
          .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
            .map { _ in } ?? Observable.just(())
    }
    
    private func showAlert(qrCase: QRCases) -> Observable<Void> {
        return Observable.just(())
    }
}
