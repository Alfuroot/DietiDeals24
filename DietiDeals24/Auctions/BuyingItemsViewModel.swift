import Foundation
import SwiftUI

@MainActor
class BuyingItemViewModel: ObservableObject {
    @Published var auction: Auction
    @Published var userBid: Float?
    @Published var bidStatus: String = "Checking..."
    @Published var auctionStatusColor: Color = .gray

    private let dataLoader = DataLoader()

    init(auction: Auction) {
        self.auction = auction
        self.userBid = nil
        Task {
            await checkBidStatus()
        }
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
        return "Status: \(bidStatus)"
    }

    var highestBidText: String {
        return "Highest Bid: \(auction.currentPrice)"
    }

    var imageUrl: URL? {
        guard let urlString = auction.auctionItem?.imageUrl else {
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

    // MARK: - Check if user is leading or outbid
    private func checkBidStatus() async {
            do {
                let bids = try await dataLoader.fetchBidsForAuction(auctionId: auction.id)
                let sortedBids = bids.sorted(by: { $0.timestamp > $1.timestamp })

                if let latestBid = sortedBids.first {
                    DispatchQueue.main.async {
                        if latestBid.bidderID == User.shared.id {
                            self.bidStatus = "You are leading"
                            self.auctionStatusColor = .green
                            self.userBid = latestBid.amount
                        } else {
                            self.bidStatus = "You have been outbid"
                            self.auctionStatusColor = .red
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.bidStatus = "No bids placed"
                        self.auctionStatusColor = .gray
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.bidStatus = "Error checking bid status"
                    self.auctionStatusColor = .gray
                }
            }
        }
}
