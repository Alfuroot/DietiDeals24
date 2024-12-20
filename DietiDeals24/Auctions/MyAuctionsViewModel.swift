import Foundation
import Combine

@MainActor
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
        Task {
            await dataLoader.getMyActiveAuctions()
            
            await MainActor.run {
                self.auctions = self.dataLoader.myAuctions
                self.isLoading = false
            }
        }
    }

    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }

    var sortedAuctions: [Auction] {
        auctions.sorted { lhs, rhs in
            let lhsStatus = lhs.isAuctionActive() ? AuctionStatus.active : AuctionStatus.ended
            let rhsStatus = rhs.isAuctionActive() ? AuctionStatus.active : AuctionStatus.ended
            
            if lhsStatus != rhsStatus {
                return lhsStatus.rawValue < rhsStatus.rawValue
            }
            return lhs.endDate < rhs.endDate
        }
    }
}
