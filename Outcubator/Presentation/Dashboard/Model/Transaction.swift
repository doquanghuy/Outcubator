//
//  Transaction.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import Foundation

public struct Transaction {
    public let uid: String
    public let companyName: String
    public let currency: String
    public let amount: Double
    public let fee: Double
    public let createdTime: TimeInterval
    public let isCredit: Bool
    public let userId: String
    
    init(domain: TransactionDomain) {
        self.uid = domain.uid
        self.companyName = domain.companyName
        self.currency = domain.currency
        self.amount = domain.amount
        self.fee = domain.fee
        self.createdTime = domain.createdTime
        self.isCredit = domain.isCredit
        self.userId = domain.userId
    }
    
    init(uid: String, companyName: String, currency: String, amount: Double, fee: Double, createdTime: TimeInterval, isCredit: Bool, userId: String) {
        self.uid = uid
        self.companyName = companyName
        self.currency = currency
        self.amount = amount
        self.fee = fee
        self.createdTime = createdTime
        self.isCredit = isCredit
        self.userId = userId
    }
    
    func asDomain() -> TransactionDomain {
        return .init(uid: uid, companyName: companyName, currency: currency, amount: amount, fee: fee, createdTime: createdTime, isCredit: isCredit, userId: userId)
    }
}

extension Transaction {
    static var companyName: String {
        let random = Int.random(in: 0..<Constants.Transaction.companies.count)
        return Constants.Transaction.companies[random]
    }
    
    static var currency: String {
        let random = Int.random(in: 0..<Constants.Transaction.currencies.count)
        return Constants.Transaction.currencies[random]
    }
    
    static var amount: Double {
        return Double.random(in: 0...1000000)
    }
    
    static var fee: Double {
        return Double.random(in: 0...1000000)
    }
    
    static var isCredit: Bool {
        return true
    }
}
