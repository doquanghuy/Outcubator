//
//  TransactionPlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 19/05/2021.
//

import UIKit
import RealmSwift

final class RMTransaction: Object {
    @objc dynamic var uid: String = ""
    @objc dynamic var companyName: String = ""
    @objc dynamic var currency: String = ""
    @objc dynamic var amount: Double = 0.0
    @objc dynamic var fee: Double = 0.0
    @objc dynamic var createdTime: TimeInterval = 0.0
    @objc dynamic var userId: String = ""
    @objc dynamic var isCredit: Bool = true
}

extension RMTransaction: DomainConvertibleType {
    func asDomain() -> TransactionDomain {
        return TransactionDomain(uid: uid, companyName: companyName, currency: currency, amount: amount, fee: fee, createdTime: createdTime, isCredit: isCredit, userId: userId)
    }
}

extension TransactionDomain: RealmRepresentable {
    func asRealm() -> RMTransaction {
        return RMTransaction.build {object  in
            object.uid = uid
            object.companyName = companyName
            object.currency = currency
            object.amount = amount
            object.fee = fee
            object.createdTime = createdTime
            object.isCredit = isCredit
            object.userId = userId
        }
    }
}
