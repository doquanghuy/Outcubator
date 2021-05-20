//
//  WalletTableViewCell.swift
//  Outcubator
//
//  Created by doquanghuy on 18/05/2021.
//

import UIKit

class WalletTableViewCell: UITableViewCell {

    static var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var walletLogo: UIImageView!
    @IBOutlet weak var itemNameLabel: OCLabel!
    @IBOutlet weak var reasonLabel: OCLabel!
    @IBOutlet weak var currentcyLabel: OCLabel!
    @IBOutlet weak var nextIcon: UIImageView!
    @IBOutlet weak var rickLabel: OCLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.setupUI()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        self.itemNameLabel.font = Fonts.regular(with: self.itemNameLabel.textSize)
        self.reasonLabel.font = Fonts.regular(with: self.reasonLabel.textSize)
        self.currentcyLabel.font = Fonts.bold(with: self.currentcyLabel.textSize)
    }
    
    func configure(transaction: Transaction) {
        self.walletLogo.image = UIImage()
        self.itemNameLabel.text = transaction.companyName
        self.currentcyLabel.text = String(format: "%@ %@ %@", transaction.isCredit ? "+" : "-", transaction.currency, (transaction.amount + transaction.fee).formattedWithSeparator)
    }
}
