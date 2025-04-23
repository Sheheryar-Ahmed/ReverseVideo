//
//  SettingsTableViewCell.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 14/10/2021.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var seperatorView: UIView!
    
    // MARK: - Nib Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    // MARK: - Helper Methods
    func configure(image: String?, title: String?, cellNo: CellNumber? = CellNumber.none) {
        self.titleLabel.text = title
        
        if let imageName = image {
            iconImageView.image = UIImage(named: imageName)
        }
        
        seperatorView.isHidden = (cellNo == CellNumber.isLast || cellNo == .isFirstAndLast)
        self.containerView.clipsToBounds = true
        
        switch cellNo {
        case .isFirst:
            self.containerView.layer.cornerRadius = 5
            self.containerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        case .isLast:
            self.containerView.layer.cornerRadius = 5
            self.containerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        case .isFirstAndLast:
            self.containerView.layer.cornerRadius = 5
        default:
            break
        }
    }
}
