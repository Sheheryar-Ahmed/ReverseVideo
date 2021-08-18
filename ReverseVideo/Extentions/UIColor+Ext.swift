//
//  UIColor+Ext.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 15/02/2021.
//

import UIKit

extension UIColor {
    
    // MARK: - Properties
    class var rvOrange: UIColor? {
        return fromHex("F15922")
    }
    
    class var rvGray: UIColor? {
        return fromHex("#424242")
    }
    
    // MARK: - Helper Methods
    class func fromHex(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
