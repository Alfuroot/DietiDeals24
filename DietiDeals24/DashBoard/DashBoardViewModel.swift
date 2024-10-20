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
    
    // Computed property to filter auction items based on search and selected categories
    var filteredItems: [Auction] {
        auctions.filter { auction in
            (search.isEmpty || auction.title.localizedCaseInsensitiveContains(search) ||
             auction.description.localizedCaseInsensitiveContains(search)) &&
            (selectedCategories.isEmpty || selectedCategories.contains(auction.auctionItem.category))
        }
    }
    
    init() {
        fetchAuctionItems()
    }
    
    func fetchAuctionItems() {
        isLoading = true
        
        Task {
            do {
                await dataLoader.loadRemoteData()  // Fetch data from the DataLoader
                updateAuctionItems()  // Update the auction items array
            } catch {
                handleError(error)  // Handle errors if fetching fails
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
            self.error = error.localizedDescription  // Update error message
            self.isLoading = false  // Set loading state to false
        }
    }
}
