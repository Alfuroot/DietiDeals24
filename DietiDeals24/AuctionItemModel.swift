//
//  AuctionItemModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import Foundation

class AuctionItem: Codable, Identifiable {

    var id: String?
    var title: String?
    var description: String?
    var imageUrl: String?
    var currentBid: String?
    var bidEndDate: String?
    
    init(id: String?, title: String?, description: String, imageUrl: String?, currentBid: String?, bidEndDate: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.currentBid = currentBid
        self.bidEndDate = bidEndDate
    }
    
    init(remoteAuctionItem: RemoteAuctionItem) {
        self.id = remoteAuctionItem.id
        self.title = remoteAuctionItem.title
        self.description = remoteAuctionItem.description
        self.imageUrl = remoteAuctionItem.imageUrl
        self.currentBid = remoteAuctionItem.currentBid
        self.bidEndDate = remoteAuctionItem.bidEndDate
    }
}
