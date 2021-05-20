//
//  AppDIContainer.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

final class AppDIContainer {
    func makeAuthenDIContainer() -> AuthenDIContainer {
        let dependencies = AuthenDIContainer.Dependencies()
        return AuthenDIContainer(dependencies: dependencies)
    }
}
