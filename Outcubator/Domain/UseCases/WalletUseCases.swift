//
//  WalletUseCases.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation
import RxSwift

protocol WalletUseCases {
    func loadTransactions(user: UserDomain) -> Observable<[TransactionDomain]>
    func loadCurrencies(user: UserDomain) -> Observable<[String]>
}
