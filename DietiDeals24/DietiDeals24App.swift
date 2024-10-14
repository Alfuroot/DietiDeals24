//
//  DietiDeals24App.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI
import Firebase

@main
struct DietiDeals24App: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    init() {
            requestNotificationPermission()
            FirebaseApp.configure()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
