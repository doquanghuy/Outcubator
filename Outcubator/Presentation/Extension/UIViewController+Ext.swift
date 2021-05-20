//
//  UIViewController+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: Bundle(for: self))
        }

        return instantiateFromNib()
    }
    
    func add(_ child: UIViewController, in frame: CGRect) {
        addChild(child)
        child.view.frame = frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove() {
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
}
