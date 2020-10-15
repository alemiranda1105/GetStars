//
//  AppDelegate.swift
//  GetStars
//
//  Created by Alejandro Miranda on 29/06/2020.
//  Copyright © 2020 Marquelo S.L. All rights reserved.
//

import UIKit

import FirebaseCore
import FirebaseAuth

import GoogleMobileAds
import AdSupport
import AppTrackingTransparency

import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // InApp purchases
        IAPManager.shared.startObserving()
        
        // Config Firebase
        FirebaseApp.configure()
        
        // Google Ads
        if #available(iOS 14.0, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { _ in
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            })
        } else {
            // Fallback on earlier versions
            GADMobileAds.sharedInstance().start(completionHandler: nil)
        }
        
        //Google Login
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        let delegate = SessionStore()
        GIDSignIn.sharedInstance().delegate = delegate
        
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
    
    func applicationWillTerminate(_ application: UIApplication) {
        IAPManager.shared.stopObserving()
    }
}

