//
//  SellingItemsView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 28/09/2024.
//

import SwiftUI

struct SellingItemView: View {
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
                
                Text("Your item for sale")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                if auctionItem.bidEndDate != nil {
                    Text("Ends: \(auctionItem.formattedEndDate())")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

                Text("Current Highest Bid: \(auctionItem.currentBid ?? "")")
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
