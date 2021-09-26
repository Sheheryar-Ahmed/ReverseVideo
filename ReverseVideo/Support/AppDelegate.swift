//
//  AppDelegate.swift
//  ReverseVideo
//
//  Created by Sheheryar Ahmed on 08/02/2021.
//

import UIKit
import GoogleMobileAds
import Firebase
import Purchases

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // initializing google ads
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        
        // initializing firebase
        FirebaseApp.configure()
        
        // initializing RevenueCat
        Purchases.logLevel = .debug
        Purchases.configure(withAPIKey: RVConstants.InAppPurchase.revenueCatApiKey)
        
        // check if user is Premium
        Purchases.shared.purchaserInfo { (purchaserInfo, error) in
            if purchaserInfo?.entitlements.all["pro"]?.isActive == true {
                GlobalData.isPro = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

