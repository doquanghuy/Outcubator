//
//  ScanRepositoryPlatform.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import UIKit
import AVFoundation
import RxSwift

protocol ScanQRRepository {
    func checkAuthorization() -> Observable<ScanAuthorization>
    func start() -> Observable<Void>
    func stop() -> Observable<Void>
    func load(in scanerView: UIView) -> Observable<QRCodeDomain?>
}

final class DefaultScanQRRepository: ScanQRRepository {
    private let captureSession = AVCaptureSession()
    
    func checkAuthorization() -> Observable<ScanAuthorization> {
        return Observable.create {observer in
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            switch status {
            case .authorized:
                observer.onNext(.authorized)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video) { result in
                    if result == true {
                        observer.onNext(.authorized)
                    } else {
                        observer.onNext(.notDetermined)
                    }
                }
            case .restricted:
                observer.onNext(.restricted)
            case .denied:
                observer.onNext(.denied)
            @unknown default:
                observer.onNext(.others)
            }
            observer.onCompleted()
            
            return Disposables.create()
        }
    }
    
    func stop() -> Observable<Void> {
        let captureSession = self.captureSession
        return Observable.create {observer in
            if (captureSession.isRunning == true) {
                captureSession.stopRunning()
            }
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func start() -> Observable<Void> {
        let captureSession = self.captureSession
        return Observable.create {observer in
            if (captureSession.isRunning == false) {
                DispatchQueue.global(qos: .userInitiated).async {
                    captureSession.startRunning()
                }
            }
            observer.onNext(())
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    func load(in scanerView: UIView) -> Observable<QRCodeDomain?> {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
        return self.loadLayer(in: scanerView)
            .rx.metadata
            .map({metadataObjects in
                let objects = (metadataObjects as? [AVMetadataMachineReadableCodeObject]) ?? []
                let stringValue = objects
                    .first(where: {$0.type == .qr})?
                    .stringValue
                return QRCodeDomain.parse(text: stringValue)
            })
            .observe(on: MainScheduler.instance)
    }
    
    func createAreaScan(in cameraView: UIView, areaScan: CGRect) -> CAShapeLayer {
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        let width = cameraView.bounds.width
        let height = cameraView.bounds.height
        let areaWidth: CGFloat = areaScan.width
        let areaHeight: CGFloat = areaScan.height
        let xArea = cameraView.center.x - areaWidth/2
        let yArea = cameraView.center.y - areaHeight/2
        path.move(to: CGPoint.init(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: xArea, y: yArea))
        path.addLine(to: CGPoint(x: xArea, y: yArea + areaHeight))
        path.addLine(to: CGPoint(x: xArea + areaWidth, y: yArea + areaHeight))
        path.addLine(to: CGPoint(x: xArea + areaWidth, y: yArea))
        path.addLine(to: CGPoint(x: xArea, y: yArea))
        shape.path = path.cgPath
        shape.fillColor = Colors.black.withAlphaComponent(0.7).cgColor
        return shape
    }
    
    
    private func loadLayer(in scanerView: UIView) -> AVCaptureMetadataOutput {
        let metadataOutput = AVCaptureMetadataOutput()
        
        do {
            self.stopSession()
            guard let videoDevice = AVCaptureDevice.default(for: .video) else {
                return metadataOutput
            }
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if (captureSession.canAddInput(videoInput)) {
                captureSession.addInput(videoInput)
            } else {
                return metadataOutput
            }
            
            if (captureSession.canAddOutput(metadataOutput)) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.metadataObjectTypes = [.qr]
            } else {
                return metadataOutput
            }
            
            let frame = scanerView.bounds
            
            let previewLayer = AVCaptureVideoPreviewLayer.init(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = frame
            
            scanerView.layer.addSublayer(previewLayer)
            
            let areaWidth: CGFloat = 300
            let areaHeight: CGFloat = 300
            let areaScan = CGRect(x: scanerView.center.x - areaWidth/2, y: scanerView.center.y - areaHeight/2, width: areaWidth, height: areaHeight)
            
            let shape = self.createAreaScan(in: scanerView, areaScan: areaScan)
            scanerView.layer.insertSublayer(shape, above: previewLayer)
            
            captureSession.commitConfiguration()
            captureSession.startRunning()
            
            let rectOfInterest = previewLayer.metadataOutputRectConverted(fromLayerRect: areaScan)
            metadataOutput.rectOfInterest = rectOfInterest
            return metadataOutput
        } catch {
            return metadataOutput
        }
    }
    
    private func stopSession() {
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
}
