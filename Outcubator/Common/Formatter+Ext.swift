//
//  TimeInterval+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import Foundation

extension Formatter {
    static let ddMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MM.dd.yyyy"
        return formatter
    }()
    
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}
