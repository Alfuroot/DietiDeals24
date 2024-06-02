//
//  RemoteUser.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 02/06/24.
//

import Foundation

struct RemoteUser: Codable {
    var userId: Int?
    var username: String
    var password: String
    var codicefisc: String?
    var email: String
    var address: String?
}

enum ApiError: Error {
        case invalidUrl
        case invalidData
        case requestFailed
    }
class ApiService {
    let baseUrl = "https://0df1-2a0e-410-96c2-0-31e5-b4ec-87db-2666.ngrok-free.app"
    
    func createRemoteUser(remoteUser: RemoteUser) async throws -> RemoteUser {
            guard let url = URL(string: "\(baseUrl)/users") else { throw ApiError.invalidUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try JSONEncoder().encode(remoteUser)
            request.httpBody = jsonData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let createdRemoteUser = try JSONDecoder().decode(RemoteUser.self, from: data)
            return createdRemoteUser
        }
        
    
    func getRemoteUsers() async throws -> [RemoteUser] {
            guard let url = URL(string: "\(baseUrl)/users") else { throw ApiError.invalidUrl }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let remoteUsers = try JSONDecoder().decode([RemoteUser].self, from: data)
            return remoteUsers
        }
        
        func getRemoteUser(id: Int) async throws -> RemoteUser {
            guard let url = URL(string: "\(baseUrl)/users/\(id)") else { throw ApiError.invalidUrl }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            let remoteUser = try JSONDecoder().decode(RemoteUser.self, from: data)
            return remoteUser
        }
        
        func updateRemoteUser(remoteUser: RemoteUser) async throws -> RemoteUser {
            guard let userId = remoteUser.userId else { throw ApiError.invalidData}
            guard let url = URL(string: "\(baseUrl)/users/\(userId)") else { throw ApiError.invalidUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let jsonData = try JSONEncoder().encode(remoteUser)
            request.httpBody = jsonData
            
            let (data, _) = try await URLSession.shared.data(for: request)
            let updatedRemoteUser = try JSONDecoder().decode(RemoteUser.self, from: data)
            return updatedRemoteUser
        }
        
        func deleteRemoteUser(id: Int) async throws {
            guard let url = URL(string: "\(baseUrl)/users/\(id)") else { throw ApiError.invalidUrl }
            
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            
            let _ = try await URLSession.shared.data(for: request)
        }
    }
