//
//  VendorDashbordView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import SwiftUI

struct MyAuctionsView: View {
    @StateObject private var viewModel = MyAuctionsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    } else {
                        ForEach(viewModel.sortedAuctions, id: \.self) { auctions in
                            BuyingItemView(viewModel: BuyingItemViewModel(auction: auctions))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("My Purchases")
        }
    }
}

#Preview {
    MyAuctionsView()
}
