import Foundation
import Combine

class DataLoader: ObservableObject {
    @Published var allAuctions: [Auction] = []
    @Published var activeAuctions: [Auction] = []
    @Published var endedAuctions: [Auction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var myAuctions: [Auction] = []
    @Published var sellerAuctions: [Auction] = []
    
    private let baseUrl = "http://localhost:5000/api"
    private let session = URLSession.shared
    private let timeout: TimeInterval = 10
    private let authToken = "your_auth_token_here"
    
    // MARK: - Initialization
    init() {
        loadData()
    }
    
    // MARK: - Load Data (Local/Remote)
    func loadData() {
        Task {
            await loadRemoteData()
        }
    }
    
    func fetchAuctionsWithItems() async throws {
        guard let url = URL(string: "\(baseUrl)/auctions-with-items") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let auctions = try decoder.decode([Auction].self, from: data)
        
        self.allAuctions = auctions
    }
    
    func fetchBidsForAuction(auctionId: String) async throws -> [Bid] {
            guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)/bids") else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.timeoutInterval = timeout
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")

            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let bids = try JSONDecoder().decode([Bid].self, from: data)
            return bids
        }
    // MARK: - Load Remote Data
    @MainActor
    func loadRemoteData() async {
        isLoading = true
        defer { isLoading = false }
        
        let url = URL(string: "\(baseUrl)/auctions")!
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        
        do {
            let (data, response) = try await session.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }
            let auctions = try JSONDecoder().decode([Auction].self, from: data)
            DispatchQueue.main.async {
                self.allAuctions = auctions
                self.activeAuctions = auctions.filter { $0.isAuctionActive() }
                self.endedAuctions = auctions.filter { !$0.isAuctionActive() }
            }
        } catch {
            errorMessage = "Error fetching remote data: \(error.localizedDescription)"
        }
    }
    
    func fetchSellerAuctions() async {
        isLoading = true
        defer { isLoading = false }
        await loadRemoteData()
        
        let currentUserId = User.shared.id
        DispatchQueue.main.async {
            self.sellerAuctions = self.allAuctions.filter { $0.sellerID == currentUserId }
        }
    }

    // MARK: - Place Bid
    func placeBid(auctionId: String, bid: Bid) async throws {
        guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)/bids") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(bid)
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        await loadRemoteData()
    }
    
    // MARK: - Buyout Auction
    func buyoutAuction(auctionId: String) async throws {
        guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)/buyout") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        await loadRemoteData()
    }
    
    // MARK: - Cancel Auction
    func cancelAuction(auctionId: String) async throws {
        guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)/cancel") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (_, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        await loadRemoteData()
    }
    
    // MARK: - Load More Auctions (Pagination)
    func loadMoreData(currentPage: Int) async throws -> [Auction] {
        guard let url = URL(string: "\(baseUrl)/auctions?page=\(currentPage)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([Auction].self, from: data)
    }
    
    // MARK: - Load User Data (Local/Remote)
    func loadUserData(byEmail email: String) async throws -> User {
        guard let encodedEmail = email.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseUrl)/user/email/\(encodedEmail)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
        
        let user = try JSONDecoder().decode(User.self, from: data)
        return user
    }
    
    // MARK: - Get Auction by ID
    func getMyAuctions() async {
            isLoading = true
            defer { isLoading = false }

            do {
                let myBids = try await fetchUserBids()

                let auctionIds = Set(myBids.map { $0.auctionID })

                var auctions: [Auction] = []
                for auctionId in auctionIds {
                    if let auction = await getAuctionById(auctionId) {
                        auctions.append(auction)
                    }
                }
                DispatchQueue.main.async {
                    self.myAuctions = auctions
                }
            } catch {
                errorMessage = "Error fetching your auctions: \(error)"
            }
        }
    
    private func fetchUserBids() async throws -> [Bid] {
        guard let url = URL(string: "\(baseUrl)/bids?userId=\(User.shared.id)") else {
                throw URLError(.badURL)
            }

            var request = URLRequest(url: url)
            request.timeoutInterval = timeout
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw URLError(.badServerResponse)
            }

            let bids = try JSONDecoder().decode([Bid].self, from: data)
            return bids
        }
        
        func getAuctionById(_ auctionId: String) async -> Auction? {
            guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)") else {
                errorMessage = "Invalid URL"
                return nil
            }
            
            var request = URLRequest(url: url)
            request.timeoutInterval = timeout
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
            
            do {
                let (data, response) = try await session.data(for: request)
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return try JSONDecoder().decode(Auction.self, from: data)
            } catch {
                errorMessage = "Error fetching auction data: \(error)"
                return nil
            }
        }
    
    // MARK: - Save User Data
    func saveUserData(user: User) async throws {
        guard let url = URL(string: "\(baseUrl)/user") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try JSONEncoder().encode(user)
        let (_, response) = try await session.upload(for: request, from: data)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
    
    func createAuction(auction: Auction) async throws {
        guard let url = URL(string: "\(baseUrl)/auctions") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(auction)
        
        let requestBody = try encoder.encode(auction)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if let responseData = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseData)")
                }
                
                let errorResponse = try? JSONDecoder().decode([String: String].self, from: data)
                let errorMessage = errorResponse?["details"] ?? "An error occurred"
                throw URLError(.badServerResponse, userInfo: [NSURLErrorFailingURLStringErrorKey: errorMessage])
        }
    }
}
