//
//  RemoteAuctionItem.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 05/06/24.
//

import Foundation

struct RemoteAuctionItem: Codable {
    var id: String?
    var title: String?
    var description: String?
    var imageUrl: String?
    var currentBid: String?
    var bidEndDate: String?
}


extension ApiService {
    
    func createRemoteAuctionItem(remoteAuctionItem: RemoteAuctionItem) async throws -> RemoteAuctionItem {
        guard let url = URL(string: "\(baseUrl)/auctionItems") else { throw ApiError.invalidUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(remoteAuctionItem)
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let createdRemoteAuctionItem = try JSONDecoder().decode(RemoteAuctionItem.self, from: data)
        return createdRemoteAuctionItem
    }
    
    func getRemoteAuctionItems() async throws -> [RemoteAuctionItem] {
        guard let url = URL(string: "\(baseUrl)/auctionItems") else { throw ApiError.invalidUrl }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let remoteAuctionItems = try JSONDecoder().decode([RemoteAuctionItem].self, from: data)
        return remoteAuctionItems
    }
    
    func getRemoteAuctionItem(id: Int) async throws -> RemoteAuctionItem {
        guard let url = URL(string: "\(baseUrl)/auctionItems/\(id)") else { throw ApiError.invalidUrl }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let remoteAuctionItem = try JSONDecoder().decode(RemoteAuctionItem.self, from: data)
        return remoteAuctionItem
    }
    
    func updateRemoteAuctionItem(remoteAuctionItem: RemoteAuctionItem) async throws -> RemoteAuctionItem {
        guard let id = remoteAuctionItem.id else { throw ApiError.invalidData}
        guard let url = URL(string: "\(baseUrl)/auctionItems/\(id)") else { throw ApiError.invalidUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(remoteAuctionItem)
        request.httpBody = jsonData
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let updatedRemoteAuctionItem = try JSONDecoder().decode(RemoteAuctionItem.self, from: data)
        return updatedRemoteAuctionItem
    }
    
    func deleteRemoteAuctionItem(id: Int) async throws {
        guard let url = URL(string: "\(baseUrl)/auctionItems/\(id)") else { throw ApiError.invalidUrl }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let _ = try await URLSession.shared.data(for: request)
    }
}
