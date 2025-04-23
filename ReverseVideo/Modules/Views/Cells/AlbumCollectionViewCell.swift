//
//  AlbumCollectionViewCell.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 10/10/2021.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override var isSelected: Bool {
        didSet {
            containerView.backgroundColor = isSelected ? .rvThemeAlpha : .clear
        }
    }
    
    // MARK: - Initializers
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 5
    }

}
