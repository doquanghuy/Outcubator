//
//  OCButton.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

public class OCButton: UIButton {
    
    var textSize: CGFloat {
        return self.titleLabel?.font.pointSize ?? 16
    }
    
    @IBInspectable
    var cornerRadius: CGFloat = 6.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            clipsToBounds = cornerRadius > 0.0
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
        let pointSize = self.titleLabel?.font.pointSize
        self.titleLabel?.font = Fonts.regular(with: pointSize ?? 16)
    }
}
