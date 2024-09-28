//
//  MySalesView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 24/08/2024.
//

import SwiftUI

struct MySalesView: View {
    @StateObject private var dataLoader = DataLoader() // A data loader to fetch items being sold
    @State private var showAddAuctionView: Bool = false // State to control showing Add Auction view
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(dataLoader.sellingItems) { auctionItem in
                        SellingItemView(auctionItem: auctionItem)
                    }
                }
                .padding()
            }
            .navigationTitle("My Sales")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddAuctionView.toggle() // Show Add Auction view
                    }) {
                        Image(systemName: "plus") // Plus icon for adding auctions
                    }
                }
            }
            .sheet(isPresented: $showAddAuctionView) {
                AddAuctionView() // Present the view to add a new auction
            }
        }
        .onAppear {
            dataLoader.loadSellingItems() // Load the selling items when the view appears
        }
    }
}

// Preview provider
struct MySalesView_Previews: PreviewProvider {
    static var previews: some View {
        MySalesView()
    }
}
