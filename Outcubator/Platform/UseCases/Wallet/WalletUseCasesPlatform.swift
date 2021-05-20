//
//  WalletUseCasesPlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import RxSwift

final class WalletUseCasesPlatform<Repository>: WalletUseCases where Repository: RemoteRepository, Repository.T == TransactionDomain {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    
    func loadTransactions(user: UserDomain) -> Observable<[TransactionDomain]> {
        return repository.query(with: NSPredicate(format: "userId == %@", user.uid), sortDescriptors: [])
    }
    
    func loadCurrencies(user: UserDomain) -> Observable<[String]> {
        return repository.query(with: NSPredicate(format: "userId == %@", user.uid), sortDescriptors: [])
            .map({$0.map({$0.currency}).asSet().sorted()})
    }
}

