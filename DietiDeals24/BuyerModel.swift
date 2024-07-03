//
//  File.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 16/03/24.
//

import Foundation

class Buyer: User {
    
    var cart: [Offer] = []
    
    func addOfferta(offer: Offer) async throws {
        guard let url = URL(string: "https://example.com/api/cart/add") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(offer)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "com.example", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to add offer to cart"])
        }
        
        cart.append(offer)
    }
    
    func rimuoviOfferta(offerID: String) async throws {
        guard let url = URL(string: "https://example.com/api/cart/remove/\(offerID)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "com.example", code: 400, userInfo: [NSLocalizedDescriptionKey: "Failed to remove offer from cart"])
        }
        
        if let index = cart.firstIndex(where: { $0.id == offerID }) {
            cart.remove(at: index)
        } else {
            throw NSError(domain: "com.example", code: 404, userInfo: [NSLocalizedDescriptionKey: "Offer not found in cart"])
        }
    }
    
    func paga(payment: Payment) async throws {
        guard let url = URL(string: "https://example.com/api/payment") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(payment)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NSError(domain: "com.example", code: 400, userInfo: [NSLocalizedDescriptionKey: "Payment failed"])
        }
        
        cart.removeAll()
    }
}
