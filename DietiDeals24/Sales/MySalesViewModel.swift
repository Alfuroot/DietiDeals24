import Foundation
import Combine

class MySalesViewModel: ObservableObject {
    @Published var sellingItems: [AuctionItem] = []
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let dataLoader = DataLoader()
    
    func checkIBAN() {
        if User.shared.iban == nil {
            showAlert = true
        }
    }
    
    func loadSellingItems() {
        Task {
            isLoading = true
            do {
                await dataLoader.loadRemoteData()
                DispatchQueue.main.async {
                    self.sellingItems = self.dataLoader.sellingItems
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
}
