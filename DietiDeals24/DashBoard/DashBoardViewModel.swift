import Foundation
import Combine

class DashBoardViewModel: ObservableObject {
    @Published var selectedAuction: Auction?
    @Published var auctions: [Auction] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var availableCategories: [AuctionItemType] = []
    @Published var search: String = ""
    @Published var selectedCategories: [AuctionItemType] = []
    internal var router = DashboardRouter.shared

    private let dataLoader = DataLoader()

    var filteredItems: [Auction] {
        auctions.filter { auction in
            if let auctionItem = auction.auctionItem {
                (search.isEmpty || auction.title.localizedCaseInsensitiveContains(search) ||
                 auction.description.localizedCaseInsensitiveContains(search)) &&
                (selectedCategories.isEmpty || selectedCategories.contains(auctionItem.category))
            } else {
                (search.isEmpty || auction.title.localizedCaseInsensitiveContains(search) ||
                 auction.description.localizedCaseInsensitiveContains(search)) &&
                (selectedCategories.isEmpty)
            }
        }
    }
    
    init() {
        fetchAuctionItems()
    }
    
    func fetchAuctionItems() {
        isLoading = true
        
        Task {
            do {
                try await dataLoader.fetchAuctionsWithItems()
                updateAuctionItems()
            }
            catch {
                print(error)
            }
        }
    }
    
    private func updateAuctionItems() {
        DispatchQueue.main.async {
            self.auctions = self.dataLoader.allAuctions
            self.isLoading = false
        }
    }

    private func handleError(_ error: Error) {
        DispatchQueue.main.async {
            self.error = error.localizedDescription
            self.isLoading = false
        }
    }
}
