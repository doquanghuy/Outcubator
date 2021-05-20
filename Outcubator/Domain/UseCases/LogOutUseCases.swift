//
//  LogOutUseCases.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation
import RxSwift

protocol LogoutUseCases {
    func execute(query: LogoutQuery) -> Observable<Void>
}
