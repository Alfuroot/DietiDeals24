//
//  ContentView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import SwiftUI


struct ContentView: View {
    @State var loggedIn: Bool = false
    var body: some View {
        if loggedIn {
            TabView{
                LoginView()
                    
            }
        }
        else {
            TabView{
                DashBoard().tabItem {
                    Image(systemName: "1.circle")
                    Text("Active")
                }
                MyAuctionsView().tabItem{
                    Image(systemName: "1.circle")
                    Text("My purchases")
                }
                MySalesView().tabItem{
                    Image(systemName: "1.circle")
                    Text("My sales")
                }
                PersonalAreaView().tabItem {
                    Image(systemName: "1.circle")
                    Text("Profile")
                }
            }
        }
    }
}

struct ContentView_Preview: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
