//
//  SettingTableViewHeader.swift
//  iOSbackgroundChanger
//
//  Created by Umar on 18/02/2021.
//  Copyright © 2021 The Sheheryar Ahmed. All rights reserved.
//

import UIKit

protocol SettingTableViewHeaderDelegate {
    func continueButtonTapped(_ sender: UIButton)
}

class SettingTableViewHeader: UIView {

    // MARK: - Properties
    var delegate: SettingTableViewHeaderDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Nib Methods
    override func willMove(toWindow newWindow: UIWindow?) {
        self.backgroundColor = .rvBlack
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true

        titleLabel.text = "Reverse Video Pro"
        continueButton.layer.cornerRadius = 4
        continueButton.layer.borderWidth = 1
        continueButton.layer.borderColor = UIColor.rvThemeAlpha.cgColor
        continueButton.backgroundColor = .rvThemeAlpha.withAlphaComponent(0.2)
    }
    
    // MARK: - IBActions
    @IBAction func continueButtonTapped(_ sender: UIButton) {
        delegate?.continueButtonTapped(sender)
    }
}
