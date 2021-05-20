//
//  ProfileCell.swift
//  Outcubator
//
//  Created by doquanghuy on 15/05/2021.
//

import UIKit

class ProfileCell: UITableViewCell {
    
    static var identifier: String { return String(describing: self) }
    
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var detailLabel: OCLabel!
    @IBOutlet weak var nextIcon: UIImageView!
    
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
        self.detailLabel.font = Fonts.regular(with: self.detailLabel.textSize)
        self.detailLabel.textColor = Colors.black
        self.nextIcon.image = Images.icNext
    }
    
    func configure(model: ProfileModel) {
        self.profileIcon.image = model.icon
        self.detailLabel.text = model.text
    }
}
