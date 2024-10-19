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
                buyoutPrice: buyoutPriceValue,
                decrementAmount: decrementAmountValue,
                decrementInterval: decrementIntervalValue * 60,
                floorPrice: floorPriceValue
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
                auctionItem: auctionItem
            )
        }
        
        saveAuction(auction: auction)
    }
    
    private func saveAuction(auction: Auction) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let jsonData = try encoder.encode(auction)
            let jsonString = String(data: jsonData, encoding: .utf8) ?? ""
            print("Encoded JSON: \(jsonString)")
            
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let fileURL = documentDirectory.appendingPathComponent("auctions.json")
            
            if FileManager.default.fileExists(atPath: fileURL.path) {
                var existingData = try Data(contentsOf: fileURL)
                
                
                existingData.append(jsonData)
                existingData.append("\n]".data(using: .utf8)!) // Close the JSON array
                try existingData.write(to: fileURL)
            } else {
                let jsonArray = "[\n" + jsonString + "\n]"
                try jsonArray.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            
            print("Auction added to JSON file successfully!")
        } catch {
            print("Error encoding auction: \(error.localizedDescription)")
        }
    }
}
