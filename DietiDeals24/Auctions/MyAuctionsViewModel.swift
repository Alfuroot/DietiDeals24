import Foundation
import Combine

class MyAuctionsViewModel: ObservableObject {
    @Published var buyingItems: [AuctionItem] = []
    @Published var isLoading = false
    @Published var error: String?
    
    private let dataLoader = DataLoader()

    init() {
        fetchBuyingItems()
    }
    
    func fetchBuyingItems() {
        isLoading = true
        Task {
            do {
                await dataLoader.loadRemoteData()
                DispatchQueue.main.async {
                    self.buyingItems = self.dataLoader.buyingItems
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }

    var sortedBuyingItems: [AuctionItem] {
        buyingItems.sorted {
            if $0.auctionStatus == "Outbid" && $1.auctionStatus == "Leading" {
                return true
            } else if $0.auctionStatus == "Leading" && $1.auctionStatus == "Outbid" {
                return false
            }
            return false
        }
    }
}
