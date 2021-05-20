//
//  Fonts.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

public struct Fonts {
    /// Size of font.
    public static let pointSize: CGFloat = 16
    
    public static var light: UIFont {
      return light(with: Fonts.pointSize)
    }
    
    public static var regular: UIFont {
      return regular(with: Fonts.pointSize)
    }
    
    public static var medium: UIFont {
      return medium(with: Fonts.pointSize)
    }
    
    public static var semiBold: UIFont {
      return semiBold(with: Fonts.pointSize)
    }
    
    public static var bold: UIFont {
      return bold(with: Fonts.pointSize)
    }
    
    /**
     Roboto with size font.
     - Parameter with size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func light(with size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .light)
    }
    public static func regular(with size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    public static func medium(with size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .medium)
    }
    public static func semiBold(with size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    public static func bold(with size: CGFloat) -> UIFont {
      return UIFont.systemFont(ofSize: size, weight: .bold)
    }
}
