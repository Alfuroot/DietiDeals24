import Foundation
import SwiftUI

class BuyingItemViewModel: ObservableObject {
    @Published var auction: Auction
    @Published var userBid: Float?

    init(auction: Auction) {
        self.auction = auction
        self.userBid = nil
    }

    var itemTitle: String {
        auction.title
    }

    var userBidText: String {
        guard let bidValue = userBid else {
            return "Your Bid: N/A"
        }
        return "Your Bid: \(bidValue)"
    }

    var bidEndDateText: String {
        return "Ends: \(formattedDate(auction.endDate))"
    }

    var auctionStatusText: String {
        return "Status: \(auction.auctionType.rawValue)"
    }

    var highestBidText: String {
        return "Highest Bid: \(auction.currentPrice)"
    }
    
    var auctionStatusColor: Color {
        true ? .red : .green
    }

    var imageUrl: URL? {
        guard let urlString = auction.auctionItem.imageUrl else {
            return nil
        }
        return URL(string: urlString)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
