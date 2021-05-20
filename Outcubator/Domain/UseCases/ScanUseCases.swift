//
//  ScanUseCases.swift
//  Outcubator
//
//  Created by doquanghuy on 16/05/2021.
//

import Foundation
import RxSwift
import AVFoundation
protocol ScanUseCases {
    func checkAuthorized() -> Observable<ScanAuthorization>
    func load(in view: UIView) -> Observable<QRCodeDomain?>
    func stop() -> Observable<Void>
    func start() -> Observable<Void>
    func transactions(user: UserDomain) -> Observable<[TransactionDomain]>
    func makePayment(qrCode: QRCodeDomain, user: UserDomain) -> Observable<TransactionDomain>
}
