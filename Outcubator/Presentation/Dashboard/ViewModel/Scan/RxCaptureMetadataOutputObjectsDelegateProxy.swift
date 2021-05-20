//
//  RxCaptureMetadataOutputObjectsDelegateProxy.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import Foundation
import AVFoundation
import RxSwift
import RxCocoa

extension Reactive where Base: AVCaptureMetadataOutput {

    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    public var delegate: DelegateProxy<AVCaptureMetadataOutput, AVCaptureMetadataOutputObjectsDelegate> {
        return RxCaptureMetadataOutputObjectsDelegateProxy.proxy(for: base)
    }

    public var metadata: Observable<[AVMetadataObject]> {
        return delegate
                .methodInvoked(#selector(AVCaptureMetadataOutputObjectsDelegate.metadataOutput(_:didOutput:from:)))
                .map { params in
                    params[1] as! [AVMetadataObject] // swiftlint:disable:this force_cast
                }
    }
}

extension AVCaptureMetadataOutput: HasDelegate {
    public typealias Delegate = AVCaptureMetadataOutputObjectsDelegate

    // MARK: HasDelegate
    public var delegate: AVCaptureMetadataOutputObjectsDelegate? {
        get {
            return metadataObjectsDelegate
        }
        set(newValue) {
            setMetadataObjectsDelegate(newValue, queue: DispatchQueue.main)
        }
    }
}

open class RxCaptureMetadataOutputObjectsDelegateProxy:
        DelegateProxy < AVCaptureMetadataOutput,
        AVCaptureMetadataOutputObjectsDelegate>,
        DelegateProxyType,
        AVCaptureMetadataOutputObjectsDelegate {

    /// Typed parent object.
    public weak private(set) var output: AVCaptureMetadataOutput?

    /// - parameter tabBar: Parent object for delegate proxy.
    public init(metadataOutput: ParentObject) {
        self.output = metadataOutput
        super.init(parentObject: metadataOutput, delegateProxy: RxCaptureMetadataOutputObjectsDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register {
            RxCaptureMetadataOutputObjectsDelegateProxy(metadataOutput: $0)
        }
    }

    /// For more information take a look at `DelegateProxyType`.
    open class func currentDelegate(for object: ParentObject) -> AVCaptureMetadataOutputObjectsDelegate? {
        return object.delegate
    }

    /// For more information take a look at `DelegateProxyType`.
    open class func setCurrentDelegate(_ delegate: AVCaptureMetadataOutputObjectsDelegate?, to object: ParentObject) {
        object.delegate = delegate
    }

}
