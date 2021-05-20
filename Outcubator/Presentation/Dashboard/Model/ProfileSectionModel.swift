//
//  ProfileSectionModel.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import Foundation
import RxDataSources

struct ProfileSectionModel {
    var header: String
    var items: [ProfileModel]
}

extension ProfileSectionModel: SectionModelType {
    typealias Item = ProfileModel
    
    init(original: ProfileSectionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
