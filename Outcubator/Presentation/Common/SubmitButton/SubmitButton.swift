//
//  SubmitButton.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit

public protocol SubmitButtonProtocol: UIView {
    var bgColor: UIColor {get set}
    var text: String? {get set}
    var textColor: UIColor? {get set}
}

public class SubmitButton: OCButton, SubmitButtonProtocol {
    public var textColor: UIColor? {
        didSet {
            self.setTitleColor(textColor, for: .normal)
        }
    }
    
    public var bgColor: UIColor = Colors.lightningYellow {
        didSet {
            self.backgroundColor = bgColor
        }
    }
    public var text: String? {
        didSet {
            self.setTitle(text, for: .normal)
        }
    }
    
    public override var bounds: CGRect {
        didSet {
            decor()
        }
    }
    
    private func decor() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 20.0
        self.backgroundColor = bgColor
        self.setTitle(text, for: .normal)
        self.setTitleColor(textColor, for: .normal)
    }
}
