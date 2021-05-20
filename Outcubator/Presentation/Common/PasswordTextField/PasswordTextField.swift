//
//  PasswordTextField.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

class PasswordTextField: OCTextField {
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 50)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
