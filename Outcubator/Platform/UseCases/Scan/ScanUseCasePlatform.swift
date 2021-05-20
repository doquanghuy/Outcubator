//
//  ScanUseCasePlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation
import AVFoundation
import RxSwift

final class ScanUseCasesPlatform<Repository>: ScanUseCases where Repository: RemoteRepository, Repository.T == TransactionDomain {
    private let repository: Repository
    private let scanRepository: ScanQRRepository
    
    init(repository: Repository, scanRepository: ScanQRRepository) {
        self.repository = repository
        self.scanRepository = scanRepository
    }
    
    func checkAuthorized() -> Observable<ScanAuthorization> {
        return scanRepository.checkAuthorization()
    }
    
    func load(in view: UIView) -> Observable<QRCodeDomain?> {
        return scanRepository.load(in: view)
    }
    
    func stop() -> Observable<Void> {
        return scanRepository.stop()
    }
    
    func start() -> Observable<Void> {
        return scanRepository.start()
    }
    
    func transactions(user: UserDomain) -> Observable<[TransactionDomain]> {
        return repository.query(with: NSPredicate(format: "userId == %@", user.uid), sortDescriptors: [])
            .observe(on: MainScheduler.instance)
    }
    
    func makePayment(qrCode: QRCodeDomain, user: UserDomain) -> Observable<TransactionDomain> {
        let transaction = TransactionDomain(uid: UUID().uuidString, companyName: qrCode.companyName, currency: qrCode.currency, amount: qrCode.amount, fee: qrCode.fee, createdTime: Date().timeIntervalSince1970, isCredit: false, userId: user.uid)
        return repository.save(entity: transaction)
            .observe(on: MainScheduler.instance)
    }
}

