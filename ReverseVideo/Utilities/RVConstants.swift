//
//  RVConstants.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 17/03/2021.
//

import Foundation

struct RVConstants {
    
    struct keys {
        static var creationDate = "creationDate"
    }
    
     struct adIDs {
        static var testInterstitial = "ca-app-pub-3940256099942544/4411468910"
        static var testBanner = "ca-app-pub-3940256099942544/2934735716"
        
        static var exportInterstitial: String {
            #if DEBUG
            return testInterstitial
            #else
            return ""
            #endif
        }
        
        static var editorBanner: String {
            #if DEBUG
            return testBanner
            #else
            return ""
            #endif
        }
     }
    
    struct InAppPurchase {
        static let sharedSecret = ""
        static let revenueCatApiKey = ""
        
        static let weeklyPackageID = ""
        static let monthlyPackageID = ""
        static let yearlyPackageID = ""
    }
    
    struct URLs {
        static let privacyPolicy = "https://sheheryarahmed.com/reverse-video-privacy-policy/"
        static let termsOfUse = "https://sheheryarahmed.com/reverse-video-privacy-policy/"
    }
}
