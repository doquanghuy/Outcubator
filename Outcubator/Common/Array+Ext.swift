//
//  Array+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation

extension Array where Element: Hashable {
    func asSet() -> Self {
        return Array(Set(self))
    }
}
