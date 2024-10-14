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
    var category: AuctionItemType?
    var auctionType: AuctionType?

    var userBid: String?
    var auctionStatus: String?
    
    var isSeller: Bool
    
    init(id: String = UUID().uuidString, title: String, description: String, imageUrl: String?, currentBid: String, bidEndDate: String?, auctionType: AuctionType?, userBid: String? = nil, auctionStatus: String? = nil, isSeller: Bool = false) {
           self.id = id
           self.title = title
           self.description = description
           self.imageUrl = imageUrl
           self.currentBid = currentBid
           self.bidEndDate = bidEndDate
           self.auctionType = auctionType
           self.userBid = userBid
           self.auctionStatus = auctionStatus
           self.isSeller = isSeller
       }

    func formattedEndDate() -> String {
        guard let bidEndDate = bidEndDate else { return "No end date" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = dateFormatter.date(from: bidEndDate) {
            let displayFormatter = DateFormatter()
            displayFormatter.dateStyle = .medium
            displayFormatter.timeStyle = .short
            return displayFormatter.string(from: date)
        }
        return "Invalid date"
    }
}
