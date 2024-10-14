//
//  AppDelegate.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 14/10/2024.
//

import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Manually log app open event
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }

    // Implement other app delegate methods as necessary
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Track when the app goes to the background
        Analytics.logEvent("app_background", parameters: nil)
    }
}
