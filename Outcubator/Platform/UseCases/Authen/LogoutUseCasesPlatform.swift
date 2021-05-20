//
//  LogoutUseCasesPlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import RxSwift

final class LogoutUseCasesPlatform<Repository>: LogoutUseCases where Repository: RemoteRepository, Repository.T == UserDomain {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }
    func execute(query: LogoutQuery) -> Observable<Void> {
        return Observable.just(())
    }
}
