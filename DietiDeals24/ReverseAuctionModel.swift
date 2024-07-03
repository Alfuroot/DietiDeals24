//
//  ReverseAuction.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 16/03/24.
//

import Foundation

class ReverseAuction: Auction,Identifiable {
    var decrease: String?
    var decreaseTimer: String?
    var minimumPrice: String?

    // Initializer with all properties
    init(initialPrize: Float? = nil, ID: String? = nil, decrease: String? = nil, decreaseTimer: String? = nil, minimumPrice: String? = nil) {
        self.decrease = decrease
        self.decreaseTimer = decreaseTimer
        self.minimumPrice = minimumPrice
        super.init(initialPrize: initialPrize, ID: ID)
    }

    // Initializer using a RemoteReverseAuction instance
    init(remoteReverseAuction: RemoteReverseAuction) {
        self.decrease = remoteReverseAuction.decrease
        self.decreaseTimer = remoteReverseAuction.decreaseTimer
        self.minimumPrice = remoteReverseAuction.minimumPrice
        super.init(initialPrize: remoteReverseAuction.initialPrize, ID: remoteReverseAuction.ID)
    }

    // Required initializer for Decodable
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.decrease = try container.decodeIfPresent(String.self, forKey: .decrease)
        self.decreaseTimer = try container.decodeIfPresent(String.self, forKey: .decreaseTimer)
        self.minimumPrice = try container.decodeIfPresent(String.self, forKey: .minimumPrice)
        try super.init(from: decoder)
    }

    // Coding keys for Decodable
    enum CodingKeys: String, CodingKey {
        case decrease
        case decreaseTimer
        case minimumPrice
    }
}
