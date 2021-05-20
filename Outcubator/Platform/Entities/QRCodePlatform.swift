//
//  QRCodePlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation

protocol Transactionable: Codable {
    static func parse(text: String?) -> QRCodeDomain?
}

extension QRCodeDomain: Transactionable {    
    static func parse(text: String?) -> QRCodeDomain? {
        guard let text = text?.data(using: .utf8) else {return nil}
        return try? JSONDecoder().decode(QRCodeDomain.self, from: text)
    }
}
