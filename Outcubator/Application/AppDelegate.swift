//
//  AppDelegate.swift
//  Outcubator
//
//  Created by doquanghuy on 12/05/2021.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    let appDIContainer = AppDIContainer()
    var window: UIWindow?
    var appFlowCoordinator: AppFlowCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(navigationController: navigationController,
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        return true
    }
}

