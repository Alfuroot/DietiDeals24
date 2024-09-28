//
//  RemotereverseAuction.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 05/06/24.
//

import Foundation

class RemoteReverseAuction: Codable {
    var id: String
    var title: String
    var description: String
    var initialPrice: Float
    var currentPrice: Float
    var startDate: Date
    var endDate: Date
    var status: AuctionStatus
    var bids: [Bid]
    var decreaseAmount: Float
    var decreaseInterval: TimeInterval
    var minimumPrice: Float
}
