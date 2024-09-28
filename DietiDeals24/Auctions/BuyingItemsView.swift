//
//  BuyingItemsView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 28/09/2024.
//

import SwiftUI

struct BuyingItemView: View {
    var auctionItem: AuctionItem
    
    var body: some View {
        HStack {
            if let imageUrl = auctionItem.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                } placeholder: {
                    ProgressView()
                        .frame(width: 50, height: 50)
                }
            } else {
                Image(systemName: "camera")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 8) {
                Text(auctionItem.title)
                    .font(.headline)
                    .lineLimit(1)

                Text("Your Bid: \(auctionItem.userBid ?? "N/A")")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                if let bidEndDate = auctionItem.bidEndDate {
                    Text("Ends: \(auctionItem.formattedEndDate())")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                if let status = auctionItem.auctionStatus {
                    Text("Status: \(status)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(status == "Leading" ? .green : .red)
                }

                Text("Highest Bid: \(auctionItem.currentBid)")
                    .font(.title3)
                    .fontWeight(.bold)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 3)
        .padding(.horizontal)
    }
}
