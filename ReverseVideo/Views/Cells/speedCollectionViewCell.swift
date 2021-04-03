//
//  speedCollectionViewCell.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 15/02/2021.
//

import UIKit

class speedCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var lineImageView: UIImageView!
    
    @IBOutlet weak var lineImageTopConstraint: NSLayoutConstraint!
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .rvOrange : .white
            lineImageView.tintColor = isSelected ? .rvOrange : .white
            lineImageTopConstraint.constant = isSelected ? 0.0 : 10.0
            
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
    }
    
    // MARK: - Intialziers
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configure()
    }

    // MARK: - Private Methods
    func configure() {
        label.textColor = .white
    }
}
