//
//  ImageWithTextCollectionViewCell.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 28/06/2021.
//

import UIKit

class ImageWithTextCollectionViewCell: UICollectionViewCell {

    
    // MARK: - IBOutlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Lifecycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        configure()
    }
    
    private func configure() {
        imageView.layer.cornerRadius = 15
        self.clipsToBounds = true
    }

}