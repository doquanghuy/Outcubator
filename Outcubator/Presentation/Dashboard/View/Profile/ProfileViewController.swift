//
//  ProfileViewController.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

public class ProfileViewController: UIViewController {
    @IBOutlet weak var fasterPayImage: UIImageView!
    @IBOutlet weak var fasterPayLabel: OCLabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var useNameLabel: OCLabel!
    @IBOutlet weak var usePhoneLabel: OCLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backgroundTableView: UIView!
    
    private let disposeBag = DisposeBag()
    private var viewModel: ProfileVM!
    private let didLoad = PublishSubject<Void>()
    
    static func create(with viewModel: ProfileVM) -> ProfileViewController {
        let vc = ProfileViewController.loadFromNib()
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
        self.tableView.register(type: ProfileCell.self)
        ///UILabel
        self.fasterPayImage.image = Images.icFasterPay
        self.fasterPayLabel.text = Constants.Profile.fasterPay
        self.fasterPayLabel.font = Fonts.bold(with: self.fasterPayLabel.textSize)
        
        [self.fasterPayLabel, self.useNameLabel, self.usePhoneLabel].forEach({$0.textColor = Colors.white})
        
        //UITableView
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorInset = .zero
        self.tableView.backgroundColor = .clear
        self.tableView.register(type: ProfileCell.self)
        self.tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        self.tableView.tableFooterView = UIView()
        
        self.backgroundTableView.roundCorners([.topLeft, .topRight], radius: 20)
        self.backgroundTableView.clipsToBounds = true
        
        self.avatarImage.image = Images.icAvatar
    }
    
    private func bind() {
        let input = ProfileVM.Input(didLoad: self.didLoad, didClickOnIndex: self.tableView.rx.itemSelected.asObservable())
        
        let output = self.viewModel.transform(input: input)
        
        let dataSource = RxTableViewSectionedReloadDataSource<ProfileSectionModel>(
            configureCell: { (_, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: String(describing: ProfileCell.self)) as! ProfileCell
                cell.configure(model: element)
                return cell
            },
            titleForHeaderInSection: { dataSource, sectionIndex in
                return dataSource[sectionIndex].header
            }
        )
        
        output.didLogOut
            .subscribe()
            .disposed(by: self.disposeBag)
        output.email
            .bind(to: self.usePhoneLabel.rx.text)
            .disposed(by: self.disposeBag)
        output.name
            .bind(to: self.useNameLabel.rx.text)
            .disposed(by: self.disposeBag)
        output.sections
            .bind(to: self.tableView.rx.items(dataSource: dataSource))
            .disposed(by: self.disposeBag)
        
        didLoad.onNext(())
    }
}
