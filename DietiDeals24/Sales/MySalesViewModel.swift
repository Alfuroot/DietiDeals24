import Foundation
import Combine

@MainActor
class MySalesViewModel: ObservableObject {
    @Published var sellingAuctions: [Auction] = []
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let dataLoader = DataLoader()
    
    func checkIBAN() -> Bool {
        if let iban = User.shared.iban, !iban.isEmpty {
            return true
        } else {
            showAlert = true
            return false
        }
    }
    
    
    @MainActor
    func loadSellingAuctions() {
        isLoading = true
        Task {
            await dataLoader.loadRemoteData()
            await dataLoader.fetchSellerAuctions()
            self.sellingAuctions = self.dataLoader.sellerAuctions
            self.isLoading = false
        }
    }
}
