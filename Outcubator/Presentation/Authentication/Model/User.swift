//
//  User.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation

public struct User {
    let uid: String
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    
    var fullName: String {
        return firstName + " " + lastName
    }
    
    init?(domain: UserDomain?) {
        guard let domain = domain else {return nil}
        self.uid = domain.uid
        self.email = domain.email
        self.password = domain.password
        self.firstName = domain.firstName
        self.lastName = domain.lastName
    }
    
    func asDomain() -> UserDomain {
        return .init(uid: uid, email: email, password: password, firstName: firstName, lastName: lastName)
    }
}
