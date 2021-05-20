//
//  OCTextField.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

class OCTextField: UITextField {
    
    var textSize: CGFloat {
        return self.font?.pointSize ?? 16
    }
    
    @IBInspectable var placeHolderColor: UIColor? {
         get {
             return self.placeHolderColor
         }
         set {
             self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
         }
     }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    private func commonInit() {
        let pointSize = self.font?.pointSize
        self.font = Fonts.regular(with: pointSize ?? 16)
    }
    
    func configUI(placeHolderColor: UIColor = Colors.white,
                  textColor: UIColor = Colors.white,
                  bgColor: UIColor = Colors.rum)
    {
        self.placeHolderColor = placeHolderColor
        self.textColor = textColor
        self.backgroundColor = bgColor
    }
}
