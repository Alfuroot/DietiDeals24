//
//  RemoteFixedTimeAuction.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 05/06/24.
//

import Foundation

struct RemoteFixedTimeAuction: Codable {
    var expirationDate: String?
    var maxOffer: String?
    var initialPrize: Float?
    var ID: String?
}
