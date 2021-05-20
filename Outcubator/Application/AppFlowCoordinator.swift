//
//  AppFlowCoordinator.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit
import RxSwift

final class AppFlowCoordinator {
    private let navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController,
         appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let authenDIContainer = appDIContainer.makeAuthenDIContainer()
        let flow = authenDIContainer.makeAuthenFlowCoordinator(navigationController: navigationController)
        flow.start()
    }
}

