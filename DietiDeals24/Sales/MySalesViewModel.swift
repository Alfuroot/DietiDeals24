import Foundation
import Combine

class MySalesViewModel: ObservableObject {
    @Published var sellingAuctions: [Auction] = []
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let dataLoader = DataLoader()
    
    init() {
        loadSellingAuctions()
    }
    
    func checkIBAN() -> Bool {
        if let iban = User.shared.iban, !iban.isEmpty {
            return true
        } else {
            showAlert = true
            return false
        }
    }

    
    func loadSellingAuctions() {
        isLoading = true // Set loading state to true
        Task {
            do {
                await dataLoader.loadRemoteData()
                await dataLoader.fetchSellerAuctions()
                DispatchQueue.main.async {
                    self.sellingAuctions = self.dataLoader.sellerAuctions
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                    self.showAlert = true
                }
            }
        }
    }
}
