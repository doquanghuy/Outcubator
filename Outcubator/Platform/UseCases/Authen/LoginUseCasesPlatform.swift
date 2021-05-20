//
//  LoginUseCasesPlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import RxSwift

final class LoginUseCasesPlatform<Repository, Local>: LoginUseCases where Repository: RemoteRepository, Repository.T == UserDomain, Local: LocalRepository, Local.T == UserDomain {
    private let repository: Repository
    private let localRepository: Local

    init(repository: Repository, local: Local) {
        self.repository = repository
        self.localRepository = local
    }
    
    func execute(query: LoginQuery) -> Observable<UserDomain?> {
        let emailPred = NSPredicate(format: "email == %@", query.email)
        let passPred = NSPredicate(format: "password == %@", query.password)
        let pred = NSCompoundPredicate(andPredicateWithSubpredicates: [emailPred, passPred])
        return self.repository.query(with: pred, sortDescriptors: [])
            .flatMap({Observable.just($0.first)})
            .flatMap({self.processLocal(user: $0)})
            .observe(on: MainScheduler.instance)
    }
    
    func load() -> Observable<(userName: String?, password: String?)> {
        return self.localRepository
            .get()
            .map({($0?.email, $0?.password)})
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

