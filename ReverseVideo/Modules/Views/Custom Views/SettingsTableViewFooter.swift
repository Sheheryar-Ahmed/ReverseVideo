//
//  SettingsTableViewFooter.swift
//  iOSbackgroundChanger
//
//  Created by Sheheryar Ahmed on 01/09/2021.
//  Copyright © 2021 The Sheheryar Ahmed. All rights reserved.
//

import UIKit

protocol SettingsTableViewFooterDelegate {
    func didTapOnTermsAndServices()
}

class SettingsTableViewFooter: UIView {

    // MARK: - Properties
    var delegate: SettingsTableViewFooterDelegate?
    
    
    // MARK: - IBActions
    @IBAction func termsOfServicesButtonPressed(_ sender: UIButton) {
        delegate?.didTapOnTermsAndServices()
    }

}
