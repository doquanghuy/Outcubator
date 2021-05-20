//
//  TransactionDomain.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import Foundation

struct TransactionDomain: Codable {
    public let uid: String
    public let companyName: String
    public var currency: String
    public let amount: Double
    public let fee: Double
    public let createdTime: TimeInterval
    public let isCredit: Bool
    public let userId: String
}

