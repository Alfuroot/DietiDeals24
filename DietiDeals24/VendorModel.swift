//
//  VendorModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 16/03/24.
//

import Foundation

class Vendor: User {
    
    func addAuction(auction: Auction) async throws {
        guard let url = URL(string: "https://example.com/api/auctions/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(auction)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "com.example", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to add auction"])
        }
    }
    
    func removeAuction(auctionID: String) async throws {
        guard let url = URL(string: "https://example.com/api/auctions/remove/\(auctionID)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "com.example", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to remove auction"])
        }
    }
}
