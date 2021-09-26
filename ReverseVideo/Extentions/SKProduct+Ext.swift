//
//  SKProduct+Ext.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 26/09/2021.
//

import Foundation
import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        print(formatter.string(from: price)!)
        return formatter.string(from: price)!
    }
    
    
    var localizedPrice12thSection: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: NSNumber(value: Int(price)/12))!
    }
}
