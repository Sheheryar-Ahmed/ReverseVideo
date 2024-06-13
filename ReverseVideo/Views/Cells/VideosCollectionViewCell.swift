//
//  VideosCollectionViewCell.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 11/10/2021.
//

import UIKit

class VideosCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var playImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            self.layer.borderWidth = isSelected ? 2 : 0
            self.layer.borderColor = isSelected ? UIColor.rvThemeAlpha.cgColor : UIColor.rvGray.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        playImageView.tintColor = .white
        self.backgroundColor = .rvBlack
        self.layer.cornerRadius = 5
    }

}
