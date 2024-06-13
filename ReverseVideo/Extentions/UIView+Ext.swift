//
//  UIView+Ext.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 14/02/2021.
//

import UIKit

extension UIView {
    
    class var identifier: String {
        return String(describing: self)
    }
    
    class var name: String {
        return identifier
    }
    
    // MARK: - Methods
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
