//
//  VendorDashbordView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import SwiftUI

struct MyAuctionsView: View {
    @StateObject private var dataLoader = DataLoader() // A data loader to fetch auctions
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(dataLoader.buyingItems) { auctionItem in
                        BuyingItemView(auctionItem: auctionItem)
                    }
                }
                .padding()
            }
            .navigationTitle("My Purchases")
        }
    }
}
