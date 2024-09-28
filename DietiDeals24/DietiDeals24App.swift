//
//  DietiDeals24App.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI

@main
struct DietiDeals24App: App {
    init() {
            requestNotificationPermission()
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
