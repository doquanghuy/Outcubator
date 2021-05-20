//
//  SignupUseCases.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation
import RxSwift

protocol SignupUseCases {
    func execute(query: SignupQuery) -> Observable<UserDomain?>
    func save(transaction: TransactionDomain) -> Observable<TransactionDomain>
}
