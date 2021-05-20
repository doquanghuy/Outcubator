//
//  WalletSectionModels.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import Foundation
import RxDataSources

struct WalletSectionModel {
    var header: String
    var items: [Transaction]
}

extension WalletSectionModel: SectionModelType {
    typealias Item = Transaction
    
    init(original: WalletSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
