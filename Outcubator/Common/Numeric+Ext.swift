//
//  Numeric+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
