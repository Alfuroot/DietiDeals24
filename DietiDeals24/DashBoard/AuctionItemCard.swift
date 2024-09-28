//
//  AuctionItemCard.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 28/09/2024.
//
import SwiftUI

struct AuctionItemCard: View {
    var auctionItem: AuctionItem

    var body: some View {
        NavigationLink(destination: AuctionDetailView(auctionItem: auctionItem)) {
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
                        ProgressView() // Display a progress indicator while loading
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
                    Text(auctionItem.title ?? "No Title")
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(auctionItem.description ?? "No Description")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)

                    if let bidEndDate = auctionItem.bidEndDate, !bidEndDate.isEmpty {
                        Text("Ends: \(auctionItem.formattedEndDate())")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }

                    Text("Current Bid: \(auctionItem.currentBid ?? "N/A")")
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
        .buttonStyle(PlainButtonStyle()) // Removes the default button styling
    }
}

// Preview provider
struct AuctionItemCard_Previews: PreviewProvider {
    static var previews: some View {
        AuctionItemCard(auctionItem: AuctionItem(id: "1", title: "Sample Item", description: "A description of the auction item.", imageUrl: "https://example.com/sample.jpg", currentBid: "$100", bidEndDate: "2024-10-01T12:00:00Z"))
    }
}
