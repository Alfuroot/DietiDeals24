//
//  ReverseAuction.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 16/03/24.
//

import Foundation

class ReverseAuction: Auction, Codable, Identifiable {
    var decrease: String?
    var decreaseTimer: String?
    var minimumPrice: String?
    
    init(decrease: String?, decreaseTimer: String?, minimumPrice: String?) {
        self.decrease = decrease
        self.decreaseTimer = decreaseTimer
        self.minimumPrice = minimumPrice
    }
    
    init(remoteReverseAuction: RemoteReverseAuction) {
        self.decrease = remoteReverseAuction.decrease
        self.decreaseTimer = remoteReverseAuction.decreaseTimer
        self.minimumPrice = remoteReverseAuction.minimumPrice
    }
}
