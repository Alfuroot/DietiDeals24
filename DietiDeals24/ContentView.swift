//
//  ContentView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI

struct ContentView: View {
    @State var loggedIn: Bool = true
    var body: some View {
        if loggedIn {
            TabView{
                BuyerView().tabItem {
                    Image(systemName: "1.circle")
                    Text("Tutte")
                }
                Text("Mie").tabItem {
                    Image(systemName: "1.circle")
                    Text("Mie")
                }
                Text("Personale").tabItem {
                    Image(systemName: "1.circle")
                    Text("Personale")
                }
            }
        }
        else {
            LoginView()
        }
    }
}
