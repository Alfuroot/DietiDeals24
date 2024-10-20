import Foundation
import SwiftUI

class AddAuctionViewModel: ObservableObject {
    @Published var auctionTitle: String = ""
    @Published var auctionItemType: AuctionItemType = .tecnologia
    @Published var auctionMinPrice: String = ""
    @Published var auctionEndDate: Date = Date()
    @Published var auctionDescription: String = ""
    @Published var auctionType: AuctionType = .classic
    
    @Published var buyoutPrice: String = ""
    @Published var decrementAmount: String = ""
    @Published var decrementInterval: String = ""
    @Published var floorPrice: String = ""
    
    @ObservedObject var dataLoader = DataLoader() // Instantiate DataLoader to access sellerID
    
    private func parsePrice(_ value: String) -> Float? {
        let sanitized = value.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".").trimmingCharacters(in: .whitespaces)
        return Float(sanitized)
    }
    
    private func validateFields() -> Bool {
        guard !auctionTitle.isEmpty, !auctionMinPrice.isEmpty, !auctionDescription.isEmpty else {
            print("Auction title, minimum price, and description are required.")
            return false
        }

        if auctionType == .reverse {
            guard !buyoutPrice.isEmpty, !decrementAmount.isEmpty, !decrementInterval.isEmpty, !floorPrice.isEmpty else {
                print("Buyout price, decrement amount, decrement interval, and floor price are required for reverse auctions.")
                return false
            }
        }

        return true
    }
    
    func addAuction() {
        guard validateFields() else {
            return
        }
        
        guard let currentBidValue = parsePrice(auctionMinPrice) else {
            print("Invalid minimum price value.")
            return
        }
        
        // Retrieve sellerID from the dataLoader
        let sellerID = User.shared.id // Assuming User.shared.id gives you the current user's ID

        let auctionItem = AuctionItem(
            title: auctionTitle,
            description: auctionDescription,
            category: auctionItemType
        )
        
        let auction: Auction
        
        if auctionType == .reverse {
            guard let buyoutPriceValue = parsePrice(buyoutPrice),
                  let decrementAmountValue = parsePrice(decrementAmount),
                  let decrementIntervalValue = TimeInterval(decrementInterval),
                  let floorPriceValue = parsePrice(floorPrice) else {
                print("Invalid input values for reverse auction.")
                return
            }
            
            auction = Auction(
                id: UUID().uuidString,
                title: auctionTitle,
                description: auctionDescription,
                initialPrice: buyoutPriceValue,
                currentPrice: buyoutPriceValue,
                startDate: Date(),
                endDate: auctionEndDate,
                auctionType: auctionType,
                auctionItem: auctionItem,
                sellerID: sellerID, buyoutPrice: buyoutPriceValue,
                decrementAmount: decrementAmountValue,
                decrementInterval: decrementIntervalValue * 60,
                floorPrice: floorPriceValue // Set sellerID here
            )
        } else {
            auction = Auction(
                id: UUID().uuidString,
                title: auctionTitle,
                description: auctionDescription,
                initialPrice: currentBidValue,
                currentPrice: currentBidValue,
                startDate: Date(),
                endDate: auctionEndDate,
                auctionType: auctionType,
                auctionItem: auctionItem,
                sellerID: sellerID
            )
        }
        
        // Use DataLoader to save auction instead of writing to file
        Task {
            do {
                try await dataLoader.createAuction(auction: auction) 
                print("Auction added successfully!")
            } catch {
                print("Error saving auction: \(error.localizedDescription)")
            }
        }
    }
}
