import Foundation
import Combine

class MyAuctionsViewModel: ObservableObject {
    @Published var auctions: [Auction] = []
    @Published var isLoading = false
    @Published var error: String?

    private let dataLoader = DataLoader()

    init() {
        fetchAuctions()
    }

    func fetchAuctions() {
        isLoading = true
        
    #if DEBUG
        dataLoader.loadLocalData()
        self.auctions = dataLoader.allAuctions
    #else
        Task {
            do {
                try await dataLoader.loadRemoteData()
                
                await MainActor.run {
                    self.auctions = self.dataLoader.allAuctions
                    self.isLoading = false
                }
            } catch {
                handleError(error)
            }
        }
    #endif
    }

    private func handleError(_ error: Error) {
        // Update error message on the main actor
        DispatchQueue.main.async {
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }

    var sortedAuctions: [Auction] {
        auctions.sorted { lhs, rhs in
            // Implement sorting based on AuctionStatus and potentially other criteria
            let lhsStatus = lhs.isAuctionActive() ? AuctionStatus.active : AuctionStatus.ended
            let rhsStatus = rhs.isAuctionActive() ? AuctionStatus.active : AuctionStatus.ended
            
            // Example sorting logic: active auctions first, then by end date
            if lhsStatus != rhsStatus {
                return lhsStatus.rawValue < rhsStatus.rawValue
            }
            return lhs.endDate < rhs.endDate
        }
    }
}
