//
//  AuctionItemModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import Foundation

struct AuctionItem {
    let id: UUID
    let title: String
    let description: String
    let imageUrl: String
    var currentBid: Double
    var bidEndDate: Date
}
