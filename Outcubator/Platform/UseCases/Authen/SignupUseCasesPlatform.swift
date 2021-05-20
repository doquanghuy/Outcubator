//
//  SignupUseCasePlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import RxSwift

final class SignupUseCasesPlatform<UserRepository, LocalStorage, TransactionRepository>: SignupUseCases where UserRepository: RemoteRepository, UserRepository.T == UserDomain, TransactionRepository: RemoteRepository, TransactionRepository.T == TransactionDomain, LocalStorage: LocalRepository, LocalStorage.T == UserDomain  {
    private let userRepository: UserRepository
    private let transactionRepository: TransactionRepository
    private let localRepository: LocalStorage

    init(userRepo: UserRepository, transRepo: TransactionRepository, local: LocalStorage) {
        self.userRepository = userRepo
        self.transactionRepository = transRepo
        self.localRepository = local
    }
    
    func execute(query: SignupQuery) -> Observable<UserDomain?> {
        return self.userRepository
            .query(with: NSPredicate(format: "email == %@", query.email), sortDescriptors: [])
            .flatMap { (users) -> Observable<UserDomain> in
                return Observable<UserDomain>.deferred {
                    if users.isEmpty {
                        return self.userRepository.save(entity: UserDomain(uid: UUID().uuidString, email: query.email, password: query.password, firstName: query.firstName, lastName: query.lastName))
                    } else {
                        return Observable.just(users.first!)
                    }
                }
            }
            .flatMap({self.processLocal(user: $0)})
            .observe(on: MainScheduler.instance)
    }
    
    func save(transaction: TransactionDomain) -> Observable<TransactionDomain> {
        return self.transactionRepository.save(entity: transaction)
            .observe(on: MainScheduler.instance)
    }
    
    private func processLocal(user: UserDomain?) -> Observable<UserDomain?> {
        return Observable.deferred {
            guard let user = user else {
                return Observable.just(nil)
            }
            return self.localRepository.save(entity: user)
        }
    }
}
