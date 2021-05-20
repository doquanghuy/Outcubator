//
//  ScanViewModel.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import Foundation
import AVFoundation
import RxSwift

enum QRCases {
    case unauthorized, notDetermined
}

protocol ScanVMInput {
    var willAppear: Observable<Void> {get}
    var willDisAppear: Observable<Void> {get}
}

protocol ScanVMOutput {
    var didShowPayment: Observable<Void> {get}
    var didShowAlert: Observable<Void> {get}
    var didStop: Observable<Void> {get}
    var didStart: Observable<Void> {get}
}

protocol ScanVMInterface {
    func transform(input: ScanVMInput, scanerView: UIView) -> ScanVMOutput
}

final class ScanVM: ScanVMInterface {
    struct Input: ScanVMInput {
        var willAppear: Observable<Void>
        var willDisAppear: Observable<Void>
    }
    
    struct Output: ScanVMOutput {
        var didShowPayment: Observable<Void>
        var didShowAlert: Observable<Void>
        var didStop: Observable<Void>
        var didStart: Observable<Void>
    }
    
    private let user: User
    private let actions: ScanActions
    private let scanUseCases: ScanUseCases
    init(user: User, actions: ScanActions, scanUseCases: ScanUseCases) {
        self.user = user
        self.actions = actions
        self.scanUseCases = scanUseCases
    }
    
    func transform(input: ScanVMInput, scanerView: UIView) -> ScanVMOutput {
        let didCheckAuthorized = input.willAppear
            .flatMap({self.scanUseCases.checkAuthorized()})
            .map({$0 == .authorized})
            .share()
        
        let showAuthorized = didCheckAuthorized
            .filter({!$0})
            .flatMap({_ in self.showAlert(qrCase: .unauthorized)})
        
        let didGetQR = didCheckAuthorized
            .filter({$0})
            .flatMap({_ in self.scanUseCases.load(in: scanerView)})
            .map({QRModel(domain: $0)})
            .distinctUntilChanged({$0?.id ?? "" == $1?.id ?? ""})
            .share()
        
        let showDetermined = didGetQR
            .filter({$0 == nil})
            .mapToVoid()
        
        let showPayment = didGetQR
            .filter({$0 != nil})
            .flatMap {self.showPayment(qr: $0!)}
        
        let showAlert = Observable.merge(showDetermined, showAuthorized)
        
        let didStop = input.willDisAppear
            .flatMap({self.scanUseCases.stop()})
        
        let didStart = didCheckAuthorized
            .filter({$0})
            .flatMap({_ in self.scanUseCases.start()})
        
        return Output(didShowPayment: showPayment, didShowAlert: showAlert, didStop: didStop, didStart: didStart)
    }
    
    private func showPayment(qr: QRModel) -> Observable<Void> {
        return self.actions.showPayment(qr)
    }
    
    private func showAlert(qrCase: QRCases) -> Observable<Void> {
        return self.actions.showAlert(qrCase)
    }
}

public struct ScanActions {
    let showPayment: (QRModel) -> Observable<Void>
    let showAlert: (QRCases) -> Observable<Void>
}
