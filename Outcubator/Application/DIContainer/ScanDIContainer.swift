//
//  ScanDIContainer.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit

final class ScanDIContainer {
    struct Dependencies {
        let user: User
    }
    
    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeScanRepository() -> ScanQRRepository {
        return DefaultScanQRRepository()
    }
    
    func makeScanUseCases() -> ScanUseCases {
        return ScanUseCasesPlatform(repository: makeRepository(), scanRepository: makeScanRepository())
    }
    
    func makeRepository() -> DefaultRemoteRepository<TransactionDomain> {
        return DefaultRemoteRepository(configuration: .defaultConfiguration)
    }
    
    func makeScanViewModel(user: User, actions: ScanActions) -> ScanVM {
        return ScanVM(user: user, actions: actions, scanUseCases: makeScanUseCases())
    }
    
    func makePaymentVM(user: User, actions: PaymentActions, qrCode: QRModel) -> PaymentVM {
        return PaymentVM(qrCode: qrCode, user: user, actions: actions, scanUseCases: makeScanUseCases())
    }
    
    func makeTransactionVM(transaction: Transaction, actions: TransactionActions) -> TransactionVM {
        return TransactionVM(transaction: transaction, actions: actions)
    }
    
    // MARK: - VC
    public func makeScanVC(actions: ScanActions) -> ScanViewController {
        return ScanViewController.create(with: makeScanViewModel(user: self.dependencies.user, actions: actions))
    }
    
    public func makePaymentVC(actions: PaymentActions, qrCode: QRModel) -> PaymentViewController {
        return PaymentViewController.create(with: makePaymentVM(user: self.dependencies.user, actions: actions, qrCode: qrCode))
    }
    
    func makeTransactionSuccess(actions: TransactionActions, transaction: Transaction) -> TransactionPopup {
        return TransactionPopup.create(viewModel: makeTransactionVM(transaction: transaction, actions: actions))
    }
}

extension ScanDIContainer: ScanFlowCoordinatorDependencies {}

