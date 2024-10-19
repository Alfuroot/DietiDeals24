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

    // Returns the current status of the auction
    var auctionStatusText: String {
        return "Status: \(auction.auctionType.rawValue)"
    }

    // Returns the highest bid text or a default message if not available
    var highestBidText: String {
        return "Highest Bid: \(auction.currentPrice)"
    }

    // Determines the color of the auction status based on whether the user is leading
    var auctionStatusColor: Color {
        true ? .red : .green
    }

    // Converts the image URL string into a URL object
    var imageUrl: URL? {
        guard let urlString = auction.auctionItem.imageUrl else {
            return nil
        }
        return URL(string: urlString)
    }

    // Helper function to format the date into a user-friendly string
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
