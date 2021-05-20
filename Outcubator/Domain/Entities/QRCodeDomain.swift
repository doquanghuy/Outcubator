//
//  ScanDomain.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation

struct QRCodeDomain: Codable {
    public let companyName: String
    public let currency: String
    public let amount: Double
    public let fee: Double
    public let isCredit: Bool
    public let id: String
    
    private enum CodingKeys: String, CodingKey {
        case id, companyName, currency, amount, fee, isCredit
    }
}
