//
//  RVConstants.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 17/03/2021.
//

import Foundation

struct RVConstants {
     struct adIDs {
        static var testInterstitial = "ca-app-pub-3940256099942544/4411468910"
        static var testBanner = "ca-app-pub-3940256099942544/2934735716"
        
        static var exportInterstitial: String {
            #if DEBUG
            return testInterstitial
            #else
            return "ca-app-pub-3489350166648651/2145047881"
            #endif
        }
        
        static var editorBanner: String {
            #if DEBUG
            return testBanner
            #else
            return "ca-app-pub-3489350166648651/6366120657"
            #endif
        }
     }
    
    struct InAppPurchase {
        static let sharedSecret = "50f493eb35e94b21ac9aabf8d6eb1a92"
        static let revenueCatApiKey = "igphqSiOtQyakrAaUaFrPCTwMBlDWsBU"
        
        static let weeklyPackageID = "$rc_weekly"
        static let monthlyPackageID = "$rc_monthly"
        static let yearlyPackageID = "$rc_annual"
    }
    
    struct URLs {
        static let privacyPolicy = "https://thesheheryarahmed.com/reverse-video-privacy-policy/"
        static let termsOfUse = "https://thesheheryarahmed.com/reverse-video-privacy-policy/"
    }
}
