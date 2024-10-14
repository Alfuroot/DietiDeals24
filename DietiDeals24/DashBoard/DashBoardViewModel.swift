import Foundation
import Combine

class DashBoardViewModel: ObservableObject {
    @Published var auctionItems: [AuctionItem] = [] // All auction items
    @Published var isLoading = false
    @Published var error: String?
    @Published var availableCategories: [AuctionItemType] = []
    @Published var search: String = ""
    @Published var selectedCategories: [AuctionItemType] = []

    private let dataLoader = DataLoader()
    
    var filteredItems: [AuctionItem] {
        var filtered = auctionItems
        
        if !search.isEmpty {
            filtered = filtered.filter { item in
                item.title.localizedCaseInsensitiveContains(search) ||
                item.description.localizedCaseInsensitiveContains(search)
            }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { item in
                guard let category = item.category else { return false }
                return selectedCategories.contains(category)
            }
        }
        
        return filtered
    }
    
    init() {
        fetchAuctionItems()
    }
    
    func fetchAuctionItems() {
        isLoading = true
        Task {
            do {
                await dataLoader.loadRemoteData()
                DispatchQueue.main.async {
                    self.auctionItems = self.dataLoader.allItems
                    self.isLoading = false
                    self.updateAvailableCategories()
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func updateAvailableCategories() {
        let categories = auctionItems.compactMap { $0.category }
        self.availableCategories = Array(Set(categories)).sorted()
    }
}
