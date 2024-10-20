import Foundation
import Combine

class DataLoader: ObservableObject {
    @Published var allAuctions: [Auction] = []
    @Published var activeAuctions: [Auction] = []
    @Published var endedAuctions: [Auction] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var myAuctions: [Auction] = []
    
    private let baseUrl = "https://example.com/api"
    private let session = URLSession.shared
    private let timeout: TimeInterval = 10
    private let authToken = "your_auth_token_here"
    
    // MARK: - Initialization
    init() {
        loadData()
    }
    
    // MARK: - Load Data (Local/Remote)
    func loadData() {
#if DEBUG
        loadLocalData() // Load data from local JSON in debug mode
#else
        Task {
            await loadRemoteData() // Fetch from remote API in production
        }
#endif
    }
    
    // MARK: - Load Local Data
    func loadLocalData() {
        guard let path = Bundle.main.path(forResource: "auction_items", ofType: "json") else {
            errorMessage = "Local data file not found"
            return
        }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let auctions = try JSONDecoder().decode([Auction].self, from: data)
            self.allAuctions = auctions
            self.activeAuctions = auctions.filter { $0.isAuctionActive() }
            self.endedAuctions = auctions.filter { !$0.isAuctionActive() }
        } catch {
            errorMessage = "Error loading local data: \(error)"
        }
    }
    
    // MARK: - Load Remote Data
    func loadRemoteData() async {
        isLoading = true
        defer { isLoading = false }
        
        let url = URL(string: "\(baseUrl)/auctions")!
        var request = URLRequest(url: url)
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
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
        
        // Optionally reload auctions after buyout
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
        
        // Optionally reload auctions after cancelation
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
        guard let url = URL(string: "\(baseUrl)/user") else {
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
                // Step 1: Fetch all bids made by the current user
                let myBids = try await fetchUserBids()

                // Step 2: Extract unique auction IDs from the bids
                let auctionIds = Set(myBids.map { $0.auctionID })

                // Step 3: Fetch the auctions based on auction IDs
                var auctions: [Auction] = []
                for auctionId in auctionIds {
                    if let auction = try await getAuctionById(auctionId) {
                        auctions.append(auction)
                    }
                }

                // Step 4: Update the published property with the fetched auctions
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

            // Decode the response data into Bid objects
            let bids = try JSONDecoder().decode([Bid].self, from: data)
            return bids
        }
        
        // Existing getAuctionById method reused here to fetch each auction by ID
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
        request.timeoutInterval = timeout
        request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        
        let data = try JSONEncoder().encode(user)
        let (_, response) = try await session.upload(for: request, from: data)
        
        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw URLError(.badServerResponse)
        }
    }
}
