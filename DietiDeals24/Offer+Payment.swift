//
//  Offer+Payment.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 03/07/24.
//

import Foundation

class Offer: Codable {
    var id: String
    var title: String
    var price: Double
    var description: String
    
    init(id: String, title: String, price: Double, description: String) {
        self.id = id
        self.title = title
        self.price = price
        self.description = description
    }
}

class Payment: Codable {
    var amount: Double
    var method: String
    
    init(amount: Double, method: String) {
        self.amount = amount
        self.method = method
    }
}
