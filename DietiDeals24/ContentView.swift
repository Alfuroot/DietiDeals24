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
                BuyerDashboardView().tabItem {
                    Image(systemName: "1.circle")
                    Text("Tutte")
                }
                FixedTimeAuctionView().tabItem{//Text("Mie").tabItem {
                    Image(systemName: "1.circle")
                    Text("Mie")
                }
                PersonalAreaView().tabItem {
                    Image(systemName: "1.circle")
                    Text("Personale")
                }
            }
        }
        else {
            TabView{
                VendorDashboardView().tabItem {
                    Image(systemName: "1.circle")
                    Text("Active")
                }
                AddAuctionView().tabItem{//Text("Mie").tabItem {
                    Image(systemName: "1.circle")
                    Text("Add")
                }
                PersonalAreaView().tabItem {
                    Image(systemName: "1.circle")
                    Text("Personale")
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
