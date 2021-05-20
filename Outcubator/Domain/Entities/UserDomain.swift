//
//  User.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation

struct UserDomain: Codable {
    public let uid: String
    public let email: String
    public let password: String
    public let firstName: String
    public let lastName: String
}
