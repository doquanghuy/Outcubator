//
//  OCGradientView.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

class OCGradientView: UIView {

    @IBInspectable var isGradient: Bool = true
    
    @IBInspectable var topColor: UIColor = UIColor(hex: 0x3023AE)
    @IBInspectable var bottomColor: UIColor = UIColor(hex: 0xC86DD7)
    
    private var gradient = CAGradientLayer()
    private var overLay = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if self.isGradient {
            /// Add Gradient
            self.backgroundColor = .clear
            self.isGradient = false
            self.gradient.removeFromSuperlayer()
            self.gradient = CAGradientLayer()
            self.gradient.frame = self.bounds
            self.gradient.colors = [topColor.cgColor, bottomColor.cgColor]
            self.gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            self.gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
            self.layer.insertSublayer(gradient, at: 0)
            
            /// Add Overlay
            self.overLay = CAShapeLayer()
            self.overLay.path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)).cgPath
            self.overLay.fillColor = UIColor(hex: 0x1C1C1C).cgColor
            self.overLay.opacity = 0.5
            self.layer.insertSublayer(self.overLay, at: 1)
        }
    }
}
