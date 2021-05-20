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
    
    init(transaction: Transaction, actions: TransactionActions) {
        self.transaction = transaction
        self.actions = actions
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
        return self.actions.close()
    }
}

public struct TransactionActions {
    let close: () -> Observable<Void>
}

