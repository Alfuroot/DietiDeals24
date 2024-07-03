//
//  AstaATempoFissoModel.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 16/03/24.
//

import Foundation

class FixedTimeAuction: Auction, Identifiable {
    var expirationDate: String?
    var maxOffer: String?

    init(initialPrize: Float? = nil, ID: String? = nil, expirationDate: String? = nil, maxOffer: String? = nil) {
        self.expirationDate = expirationDate
        self.maxOffer = maxOffer
        super.init(initialPrize: initialPrize, ID: ID)
    }

    init(remoteFixedTimeAuction: RemoteFixedTimeAuction) {
        self.expirationDate = remoteFixedTimeAuction.expirationDate
        self.maxOffer = remoteFixedTimeAuction.maxOffer
        super.init(initialPrize: remoteFixedTimeAuction.initialPrize, ID: remoteFixedTimeAuction.ID)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.expirationDate = try container.decodeIfPresent(String.self, forKey: .expirationDate)
        self.maxOffer = try container.decodeIfPresent(String.self, forKey: .maxOffer)
        try super.init(from: decoder)
    }

    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(expirationDate, forKey: .expirationDate)
        try container.encodeIfPresent(maxOffer, forKey: .maxOffer)
        try super.encode(to: encoder)
    }

    enum CodingKeys: String, CodingKey {
        case expirationDate
        case maxOffer
    }
}
