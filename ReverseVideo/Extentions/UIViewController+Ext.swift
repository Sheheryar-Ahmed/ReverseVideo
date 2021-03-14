//
//  ViewController+Ext.swift
//  CollageVyro
//
//  Created by Sheheryar Ahmed on 23/12/2020.
//

import UIKit

extension UIViewController {
    
    // MARK: - Properties
    class var identifier: String {
        return String(describing: self)
    }
    
    class var name: String {
        return identifier
    }
    
    // MARK: Methods
    func presentRVAlertOnMainThread(message : String) {
        DispatchQueue.main.async {
            let alertVC = RVAlertViewController(message: message)
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .crossDissolve
            self.present(alertVC,animated: true)
        }
    }
}
