//
//  ScanViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

public class ScanViewController: UIViewController {
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var hintLabel: OCLabel!
        
    private var viewModel: ScanVM!
    private let disposeBag = DisposeBag()
    private let willAppear = PublishSubject<Void>()
    private let willDisAppear = PublishSubject<Void>()

    static func create(with viewModel: ScanVM) -> ScanViewController {
        let vc = ScanViewController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        #if arch(i386) || arch(x86_64)
        #else
        willAppear.onNext(())
        #endif
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        willDisAppear.onNext(())
    }
    
    private func setupUI() {
        self.hintLabel.font = Fonts.regular(with: self.hintLabel.textSize)
    }
    
    private func bind() {
        let input = ScanVM.Input(willAppear: willAppear.asObservable(), willDisAppear: willDisAppear.asObservable())
        
        let output = viewModel.transform(input: input, scanerView: cameraView)
        
        output.didShowAlert
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        output.didShowPayment
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        output.didStop
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        output.didStart
            .subscribe{_ in}
            .disposed(by: disposeBag)
    }
}
