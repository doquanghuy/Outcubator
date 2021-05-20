//
//  CurrenciesSectionModel.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation
import RxDataSources

struct CurrenciesSectionModel {
    var header: String
    var items: [String]
}

extension CurrenciesSectionModel: SectionModelType {
    typealias Item = String
    
    init(original: CurrenciesSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
