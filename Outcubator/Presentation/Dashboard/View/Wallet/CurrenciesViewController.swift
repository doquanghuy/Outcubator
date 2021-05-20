//
//  CurrenciesViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 20/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public class CurrenciesViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imgView: UIImageView!
    
    private var viewModel: CurrenciesVM!
    private let disposeBag = DisposeBag()
    private let didLoad = PublishSubject<Void>()
    
    static func create(with viewModel: CurrenciesVM) -> CurrenciesViewController {
        let vc = CurrenciesViewController.loadFromNib()
        vc.viewModel = viewModel
        return vc
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.bind()
    }
    
    private func setupUI() {
        self.setupNaviBar()
        self.tableView.register(type: UITableViewCell.self)
    }
    
    private func bind() {
        let input = CurrenciesVM.Input(didLoad: self.didLoad.asObservable(), didClickBack: (self.navigationItem.leftBarButtonItem!.customView as! UIButton).rx.tap.asObservable(), didSelectCurrency: self.tableView.rx.itemSelected.map({$0.row}))
        
        let dataSource = RxTableViewSectionedReloadDataSource<CurrenciesSectionModel>(
            configureCell: { (_, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: String(describing: WalletTableViewCell.self)) ?? UITableViewCell()
                cell.textLabel?.text = element
                return cell
            }
        )
         
        let output = viewModel.transform(input: input)
        output.didBack
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        output.didLoadCurrencies
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        output.didSelect
            .subscribe{_ in}
            .disposed(by: disposeBag)
        
        didLoad.onNext(())
    }
    
    private func setupNaviBar() {
        self.navigationController?.isNavigationBarHidden = false
        /// Add back button
        let button = UIButton(type: .custom)
        button.setImage(Images.icBack, for: .normal)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
        /// Add title label
        let titleLabel = UILabel()
        titleLabel.font = Fonts.semiBold(with: 28)
        titleLabel.textColor = Colors.white
        titleLabel.text = Constants.Wallet.currencies
        self.navigationItem.titleView = titleLabel
        
        /// Set clear background navigation bar
        self.navigationController?.navigationBar.setBackgroundImage(Images.imgGradientBg, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
    }
}
