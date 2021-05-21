//
//  TransactionVM.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation
import RxSwift

protocol TransactionVMInput {
    var didload: Observable<Void> {get}
    var didClickClose: Observable<Void> {get}
}

protocol TransactionVMOutput {
    var transactionCode: Observable<String> {get}
    var didClose: Observable<Void> {get}
}

protocol TransactionVMInterface {
    func transform(input: TransactionVMInput) -> TransactionVMOutput
}

final class TransactionVM: TransactionVMInterface {
    struct Input: TransactionVMInput {
        var didload: Observable<Void>
        var didClickClose: Observable<Void>
    }
    
    struct Output: TransactionVMOutput {
        var transactionCode: Observable<String>
        var didClose: Observable<Void>
    }
    private let transaction: Transaction
    private let actions: TransactionActions
    private let reload: PublishSubject<Void>
    
    init(transaction: Transaction, actions: TransactionActions, reload: PublishSubject<Void>) {
        self.transaction = transaction
        self.actions = actions
        self.reload = reload
    }
    
    func transform(input: TransactionVMInput) -> TransactionVMOutput {
        let transaction = self.transaction
        let transactionCode = input.didload
            .map({transaction.uid})
        let didClose = input.didClickClose
            .flatMap({self.close()})
        return Output(transactionCode: transactionCode, didClose: didClose)
    }
    
    private func close() -> Observable<Void> {
        reload.onNext(())
        return self.actions.close()
    }
}

public struct TransactionActions {
    let close: () -> Observable<Void>
}

