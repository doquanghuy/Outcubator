//
//  QRCodePlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation

protocol Transactionable: Codable {
    associatedtype T
    func asDomain() -> T
    static func parse(text: String?) -> QRCodeDomain?
}

extension QRCodeDomain: Transactionable {
    func asDomain() -> TransactionDomain {
        return .init(uid: UUID().uuidString, companyName: companyName, currency: currency, amount: amount, fee: fee, createdTime: createdTime, isCredit: isCredit, userId: userId)
    }
    
    static func parse(text: String?) -> QRCodeDomain? {
        guard let text = text?.data(using: .utf8) else {return nil}
        return try? JSONDecoder().decode(QRCodeDomain.self, from: text)
    }
}
