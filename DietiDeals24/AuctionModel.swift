//
//  AuctionModel.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 16/03/24.
//

import Foundation

class Auction: Codable {
    
    var initialPrize: Float?
    var ID: String?
    
    init(initialPrize: Float? = nil, ID: String? = nil) {
            self.initialPrize = initialPrize
            self.ID = ID
        }
}
