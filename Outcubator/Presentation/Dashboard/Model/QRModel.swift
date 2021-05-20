//
//  QRModel.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation

public struct QRModel {
    public let id: String
    public let companyName: String
    public let currency: String
    public let amount: Double
    public let fee: Double
    public let isCredit: Bool
    
    init?(domain: QRCodeDomain?) {
        guard let domain = domain else {return nil}
        self.companyName = domain.companyName
        self.currency = domain.currency
        self.amount = domain.amount
        self.fee = domain.fee
        self.isCredit = domain.isCredit
        self.id = domain.id
    }
    
    func asDomain() -> QRCodeDomain {
        return .init(companyName: companyName, currency: currency, amount: amount, fee: fee, isCredit: isCredit, id: id)
    }
}
