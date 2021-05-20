//
//  CustomNavigationController.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit

/// TripiOne Common Navigation Controller
public final class CustomNavigationController: UINavigationController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
    }
}

extension CustomNavigationController: UIGestureRecognizerDelegate {}
