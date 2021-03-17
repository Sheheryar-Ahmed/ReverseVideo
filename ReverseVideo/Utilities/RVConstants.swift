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
}
