//
//  DataLoader.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 28/09/2024.
//

import Foundation
import Combine

class DataLoader: ObservableObject {
    @Published var allItems: [AuctionItem] = [] // All auction items
    @Published var buyingItems: [AuctionItem] = [] // Items you're buying
    @Published var sellingItems: [AuctionItem] = [] // Items you're selling

    init() {
        loadData()
    }
    
    func loadData() {
        #if DEBUG
        loadLocalData() // Load data from local JSON in debug mode
        #else
        loadRemoteData() // Fetch from a remote API in production
        #endif
    }
    
    func loadUserData() async throws -> User {
            #if DEBUG
            return try loadUserDataFromLocalFile()
            #else
            return try await loadUserDataFromAPI()
            #endif
        }
    
    private func loadUserDataFromLocalFile() throws -> User {
            guard let url = Bundle.main.url(forResource: "user", withExtension: "json") else {
                throw URLError(.fileDoesNotExist)
            }
            
            let data = try Data(contentsOf: url)
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        }
        
        private func loadUserDataFromAPI() async throws -> User {
            guard let url = URL(string: "https://example.com/api/user") else {
                throw URLError(.badURL)
            }
            
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // Check for a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            
            // Decode the user data
            let user = try JSONDecoder().decode(User.self, from: data)
            return user
        }
        
        // Function to save user data asynchronously
        func saveUserData(user: User) async throws {
            guard let url = URL(string: "https://example.com/api/user") else {
                throw URLError(.badURL)
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            // Encode the user data
            let data = try JSONEncoder().encode(user)
            request.httpBody = data
            
            // Perform the network request
            let (_, response) = try await URLSession.shared.upload(for: request, from: data)
            
            // Check for a valid HTTP response
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
        }
    
    func loadSellingItems() {
        #if DEBUG
        // Load data from local JSON file
        if let url = Bundle.main.url(forResource: "LocalAuctionItems", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decodedItems = try JSONDecoder().decode([AuctionItem].self, from: data)
                DispatchQueue.main.async {
                    self.sellingItems = decodedItems // Update the sellingItems on the main thread
                }
            } catch {
                print("Error loading local auction items: \(error.localizedDescription)")
            }
        }
        #else
        // Load data from remote API
        let urlString = "https://api.example.com/auctions" // Replace with your API endpoint
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching auction items: \(error.localizedDescription)")
                return
            }

            guard let data = data else { return }

            do {
                let decodedItems = try JSONDecoder().decode([AuctionItem].self, from: data)
                DispatchQueue.main.async {
                    self.sellingItems = decodedItems // Update the sellingItems on the main thread
                }
            } catch {
                print("Error decoding auction items: \(error.localizedDescription)")
            }
        }.resume()
        #endif
    }
    
    // MARK: - Loading Local Data for Debug Mode
    func loadLocalData() {
        if let path = Bundle.main.path(forResource: "auction_items", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let auctionItems = try JSONDecoder().decode([AuctionItem].self, from: data)
                self.allItems = auctionItems
                
                // For this example, assume we can split items based on a flag in the JSON data
                // Here we divide by user ownership, you can modify based on your app logic
                self.buyingItems = auctionItems.filter { $0.userBid != nil } // Items you're bidding on
                self.sellingItems = auctionItems.filter { $0.userBid == nil } // Items you're selling
                
            } catch {
                print("Error loading local data: \(error)")
            }
        }
    }
    
    // MARK: - Loading Remote Data for Production
    func loadRemoteData() {
        // Fetch data from a remote API (example placeholder)
        let url = URL(string: "https://example.com/auctions")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let auctionItems = try JSONDecoder().decode([AuctionItem].self, from: data)
                    DispatchQueue.main.async {
                        self.allItems = auctionItems
                        self.buyingItems = auctionItems.filter { $0.userBid != nil }
                        self.sellingItems = auctionItems.filter { $0.userBid == nil }
                    }
                } catch {
                    print("Error loading remote data: \(error)")
                }
            }
        }.resume()
    }
}
