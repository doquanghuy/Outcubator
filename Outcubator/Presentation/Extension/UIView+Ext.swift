//
//  UIView+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

public extension UIView {
    func fillSuperview() {
        guard let superview = self.superview else { return }
        translatesAutoresizingMaskIntoConstraints = superview.translatesAutoresizingMaskIntoConstraints
        if translatesAutoresizingMaskIntoConstraints {
            autoresizingMask = [.flexibleWidth, .flexibleHeight]
            frame = superview.bounds
        } else {
            NSLayoutConstraint.activate([
                topAnchor.constraint(equalTo: superview.topAnchor),
                bottomAnchor.constraint(equalTo: superview.bottomAnchor),
                leftAnchor.constraint(equalTo: superview.leftAnchor),
                rightAnchor.constraint(equalTo: superview.rightAnchor)
            ])
        }
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11.0, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
    
    func addShadow(color: UIColor = Colors.black.withAlphaComponent(0.2),
                    opacity: Float = 1,
                    shadowRadius: CGFloat = 3,
                    offset: CGSize = CGSize(width: 0, height: 2),
                    shadowCornerRadius: CGFloat = 4) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = offset
        self.layer.cornerRadius = shadowCornerRadius
        self.layer.masksToBounds = false
    }
}
