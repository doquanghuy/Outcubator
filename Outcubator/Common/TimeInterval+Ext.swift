//
//  TimeInterval+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import Foundation

extension TimeInterval {
    var asString: String {
        return Formatter.ddMMyyyy.string(from: Date(timeIntervalSince1970: self))
    }
}
