//
//  CustomTabbarViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit

public class CustomTabBarViewController: UITabBarController {
    private var viewModel: TabBarVM!
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = Colors.white
        self.tabBar.tintColor = Colors.lightningYellow
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        viewModel?.showWallet()
        viewModel?.showScan()
        viewModel?.showProfile()
    }
    
    public static func create(with viewModel: TabBarVM) -> CustomTabBarViewController {
        let vc = CustomTabBarViewController()
        vc.viewModel = viewModel
        return vc
    }
}
