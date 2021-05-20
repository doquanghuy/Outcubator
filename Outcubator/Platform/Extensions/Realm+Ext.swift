//
//  Realm+Ext.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import RealmSwift

extension Object {
    static func build<O: Object>(_ builder: (O) -> () ) -> O {
        let object = O()
        builder(object)
        return object
    }
}

extension SortDescriptor {
    init(sortDescriptor: NSSortDescriptor) {
        self.init(keyPath: sortDescriptor.key ?? "", ascending: sortDescriptor.ascending)
    }
}
