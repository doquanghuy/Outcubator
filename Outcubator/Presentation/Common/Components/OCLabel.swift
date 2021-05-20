//
//  OCLabel.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

class OCLabel: UILabel {
    
    var textSize: CGFloat {
        return self.font.pointSize
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.commonInit()
    }
    
    private func commonInit() {
        let pointSize = self.font.pointSize
        self.font = Fonts.regular(with: pointSize)
    }
}
