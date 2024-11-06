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
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            guard (200...299).contains(httpResponse.statusCode) else {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if let responseBody = String(data: data, encoding: .utf8) {
                    print("Response Body: \(responseBody)")
                }
                throw URLError(.badServerResponse)
            }

            let bids = try JSONDecoder().decode([Bid].self, from: data)
            return bids
        } catch {
            print("Failed to fetch bids for auction: \(error.localizedDescription)")
            throw error
        }
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
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        request.httpBody = try encoder.encode(bid)
        
        let (data, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code: \(httpResponse.statusCode)")
            if !(200...299).contains(httpResponse.statusCode) {
                if let responseData = String(data: data, encoding: .utf8) {
                    print("Response Data: \(responseData)")
                }
                throw URLError(.badServerResponse)
            }
        }
        try await updateAuctionCurrentPrice(auctionId: auctionId, newPrice: bid.amount)
        
        await loadRemoteData()
    }
    
    func updateAuctionCurrentPrice(auctionId: String, newPrice: Float) async throws {
        guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let updatePayload = ["currentPrice": newPrice]
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(updatePayload)

        let (_, response) = try await session.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print("HTTP Status Code for update: \(httpResponse.statusCode)")
            if !(200...299).contains(httpResponse.statusCode) {
                throw URLError(.badServerResponse)
            }
        }
    }
    
    // MARK: - Buyout Auction
    func buyoutAuction(auctionId: String) async throws {
        guard let url = URL(string: "\(baseUrl)/auctions/\(auctionId)/buyout") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
    
    func loadUserData(byID userID: String) async throws -> User {
        guard let encodedUserID = userID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
              let url = URL(string: "\(baseUrl)/user/id/\(encodedUserID)") else {
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
    func getMyActiveAuctions() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let myBids = try await fetchUserBids()

            let auctionIds = Set(myBids.filter { !$0.isActive }.map { $0.auctionID })

            var activeAuctions: [Auction] = []
            for auctionId in auctionIds {
                if let auction = await getAuctionById(auctionId), auction.isActive {
                    activeAuctions.append(auction)
                }
            }
            
            DispatchQueue.main.async {
                self.myAuctions = activeAuctions
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Error fetching your active auctions: \(error)"
            }
        }
    }

    
    private func fetchUserBids() async throws -> [Bid] {
        guard let userIdEncoded = User.shared.id.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseUrl)/bids?userId=\(userIdEncoded)") else {
            throw URLError(.badURL)
        }

        print("Fetching URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let (data, response) = try await session.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            if !(200...299).contains(httpResponse.statusCode) {
                print("HTTP Request failed with status code: \(httpResponse.statusCode)")
                throw URLError(.badServerResponse)
            }

            let bids = try JSONDecoder().decode([Bid].self, from: data)
            return bids

        } catch let decodingError as DecodingError {
            print("Failed to decode response: \(decodingError.localizedDescription)")
            throw decodingError
        } catch {
            print("Failed to fetch bids with error: \(error.localizedDescription)")
            throw error
        }
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
    
    func updateUserData(userId: String, updatedFields: [String: Any]) async throws {
        guard let url = URL(string: "\(baseUrl)/user/\(userId)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = try JSONSerialization.data(withJSONObject: updatedFields, options: [])
        if let jsonString = String(data: data, encoding: .utf8) {
            print("Request Body JSON: \(jsonString)")
        }
        
        let (_, response) = try await session.upload(for: request, from: data)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
            }
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
        if let jsonData = try? encoder.encode(auction), let jsonString = String(data: jsonData, encoding: .utf8) {
            print("Request JSON:", jsonString)
        }
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
