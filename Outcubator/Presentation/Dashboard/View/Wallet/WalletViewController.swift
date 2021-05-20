//
//  WalletViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public class WalletViewController: UIViewController {
    @IBOutlet weak var fasterPayIcon: UIImageView!
    @IBOutlet weak var fasterPayLabel: OCLabel!
    @IBOutlet weak var availableLabel: OCLabel!
    @IBOutlet weak var currencyLabel: OCLabel!
    @IBOutlet weak var topupLabel: OCLabel!
    @IBOutlet weak var vaultLabel: OCLabel!
    @IBOutlet weak var topUpButton: OCButton!
    @IBOutlet weak var vaultButton: OCButton!
    @IBOutlet weak var backgroundTableView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    /// Create refresh Control
    private let refreshControl = UIRefreshControl()
    
    private var viewModel: WalletVM!
    private let disposeBag = DisposeBag()
    private let didLoad = PublishSubject<Void>()

    static func create(with viewModel: WalletVM) -> WalletViewController {
        let vc = WalletViewController.loadFromNib()
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
    }
    
    private func setupUI() {
        ///UITableView
        self.tableView.register(type: WalletTableViewCell.self)
        
        ///UILabel
        self.fasterPayLabel.text = Constants.Profile.fasterPay
        self.fasterPayLabel.font = Fonts.bold(with: self.fasterPayLabel.textSize)
        
        self.availableLabel.text = Constants.Wallet.availabel
        
        self.currencyLabel.font = Fonts.semiBold(with: self.currencyLabel.textSize)
        
        self.topupLabel.text = Constants.Wallet.topUp
        
        self.vaultLabel.text = Constants.Wallet.vault
        
        [self.fasterPayLabel, self.availableLabel, self.topupLabel, self.vaultLabel, self.currencyLabel].forEach({$0?.textColor = Colors.white })
        
        ///UIImageView
        self.fasterPayIcon.image = Images.icFasterPay
        
        ///UIButton
        self.topUpButton.setImage(Images.icTopUp, for: .normal)
        self.vaultButton.setImage(Images.icVault, for: .normal)
        
        //UITableView
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = .clear
        self.tableView.refreshControl = refreshControl
        self.tableView.register(type: WalletTableViewCell.self)
        self.tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        
        self.backgroundTableView.roundCorners([.topLeft, .topRight], radius: 20)
    }
    
    private func bind() {
        let input = WalletVM.Input(didLoad: didLoad, didClickTopUp: self.topUpButton.rx.tap.asObservable(), didClickVault: self.vaultButton.rx.tap.asObservable(), didRefresh: self.refreshControl.rx.controlEvent(.valueChanged).asObservable())
        let output = self.viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<WalletSectionModel>(
            configureCell: { (_, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: String(describing: WalletTableViewCell.self)) as! WalletTableViewCell
                cell.configure(transaction: element)
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].header
            }
        )
        
        tableView.rx.delegate.methodInvoked(#selector(tableView.delegate?.tableView(_:willDisplayHeaderView:forSection:)))
            .take(until: tableView.rx.deallocated)
            .subscribe(onNext: { event in
                guard let headerView = event[1] as? UITableViewHeaderFooterView else { return }
                headerView.textLabel?.textAlignment = .center
                headerView.textLabel?.font = Fonts.regular(with: 16)
            }).disposed(by: disposeBag)
        
        output.balance
            .bind(to: self.currencyLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.didCompleteRefreshing
            .delay(.milliseconds(500), scheduler: MainScheduler.instance)
            .bind(to: self.refreshControl.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.didShowCurrencies
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        didLoad.onNext(())
    }
}
