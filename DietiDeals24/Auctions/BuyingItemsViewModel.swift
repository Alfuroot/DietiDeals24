import Foundation
import SwiftUI

class BuyingItemViewModel: ObservableObject {
    var auctionItem: AuctionItem

    init(auctionItem: AuctionItem) {
        self.auctionItem = auctionItem
    }

    var isOutbid: Bool {
        auctionItem.auctionStatus == "Outbid"
    }

    var itemTitle: String {
        auctionItem.title
    }

    var userBidText: String {
        "Your Bid: \(auctionItem.userBid ?? "N/A")"
    }

    var bidEndDateText: String {
        if auctionItem.bidEndDate != nil {
            return "Ends: \(auctionItem.formattedEndDate())"
        }
        return ""
    }

    var auctionStatusText: String {
        "Status: \(auctionItem.auctionStatus ?? "N/A")"
    }

    var highestBidText: String {
        "Highest Bid: \(auctionItem.currentBid ?? "")"
    }

    var auctionStatusColor: Color {
        auctionItem.auctionStatus == "Leading" ? .green : .red
    }

    var imageUrl: URL? {
        if let urlString = auctionItem.imageUrl {
            return URL(string: urlString)
        }
        return nil
    }
}
