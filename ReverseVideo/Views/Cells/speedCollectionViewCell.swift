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
    
    // MARK: - Properties
    override var isSelected: Bool {
        didSet {
            label.textColor = isSelected ? .rvOrange : .white
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
