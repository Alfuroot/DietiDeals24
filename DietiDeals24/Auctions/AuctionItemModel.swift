//
//  AuctionItemModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import Foundation

class AuctionItem: Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var imageUrl: String?
    var currentBid: String?
    var bidEndDate: String?
    
    // For the buying section
    var userBid: String? // The bid you placed on the item
    var auctionStatus: String? // Leading, Outbid, Won, etc.
    
    // New flag for ownership
    var isSeller: Bool // true if the user is the seller, false if bidding
    
    init(id: String = UUID().uuidString, title: String, description: String, imageUrl: String?, currentBid: String, bidEndDate: String?, userBid: String? = nil, auctionStatus: String? = nil, isSeller: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.currentBid = currentBid
        self.bidEndDate = bidEndDate
        self.userBid = userBid
        self.auctionStatus = auctionStatus
        self.isSeller = isSeller
    }

    // Optional: Helper function to convert bidEndDate to Date
    func formattedEndDate() -> String {
        guard let bidEndDate = bidEndDate else { return "No end date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // Expected format of your bid end date
        if let date = dateFormatter.date(from: bidEndDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return "Invalid date"
    }
}