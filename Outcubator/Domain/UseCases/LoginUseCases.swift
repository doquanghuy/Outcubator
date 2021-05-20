//
//  AuthenUseCases.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import Foundation
import RxSwift

protocol LoginUseCases {
    func execute(query: LoginQuery) -> Observable<UserDomain?>
    func load() -> Observable<(userName: String?, password: String?)>
}
