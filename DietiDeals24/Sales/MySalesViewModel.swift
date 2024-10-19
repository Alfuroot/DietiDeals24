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
    
    func checkIBAN() {
        // Implementation for IBAN checking goes here
    }
    
    func loadSellingAuctions() {
        isLoading = true // Set loading state to true
        Task {
            do {
                await dataLoader.loadRemoteData() // Asynchronously load remote data
                DispatchQueue.main.async {
                    self.sellingAuctions = self.dataLoader.allAuctions // Update selling auctions on the main thread
                    self.isLoading = false // Reset loading state
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription // Capture error message
                    self.isLoading = false // Reset loading state
                    self.showAlert = true // Show alert for the error
                }
            }
        }
    }
}
