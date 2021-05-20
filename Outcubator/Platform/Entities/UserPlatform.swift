//
//  Post.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import UIKit
import RealmSwift

final class RMUser: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var email: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
}

extension RMUser: DomainConvertibleType {
    func asDomain() -> UserDomain {
        return UserDomain(uid: uid, email: email, password: password, firstName: firstName, lastName: lastName)
    }
}

extension UserDomain: RealmRepresentable {
    func asRealm() -> RMUser {
        return RMUser.build {object  in
            object.uid = uid
            object.email = email
            object.firstName = firstName
            object.lastName = lastName
            object.password = password
        }
    }
}
