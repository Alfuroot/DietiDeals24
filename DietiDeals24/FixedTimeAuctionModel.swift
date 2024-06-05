//
//  AstaATempoFissoModel.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 16/03/24.
//

import Foundation

class FixedTimeAuction: Auction, Codable, Identifiable {
    var expirationDate: String?
    var maxOffer: String?
    
    init(expirationDate: String?, maxOffer: String?) {
        self.expirationDate = expirationDate
        self.maxOffer = maxOffer
    }
    
    init(remoteFixedTimeAuction: RemoteFixedTimeAuction) {
        self.expirationDate = remoteFixedTimeAuction.expirationDate
        self.maxOffer = remoteFixedTimeAuction.maxOffer
    }
}
