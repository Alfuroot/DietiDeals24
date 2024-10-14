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

    func validateFields() -> Bool {
        return !auctionTitle.isEmpty && !auctionMinPrice.isEmpty && !auctionDescription.isEmpty
    }
    
    func addAuction() {
        guard validateFields(),
              let currentBidValue = Float(auctionMinPrice.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".")),
              let buyoutPriceValue = auctionType == .reverse ? Float(buyoutPrice.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".")) : nil,
              let decrementAmountValue = auctionType == .reverse ? Float(decrementAmount.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".")) : nil,
              let decrementIntervalValue = auctionType == .reverse ? TimeInterval(decrementInterval) : nil,
              let floorPriceValue = auctionType == .reverse ? Float(floorPrice.replacingOccurrences(of: "€", with: "").replacingOccurrences(of: ",", with: ".")) : nil else {
            print("Invalid input values.")
            return
        }

        let auction: Auction
        
        if auctionType == .reverse {
            auction = Auction(id: UUID().uuidString,
                              title: auctionTitle,
                              description: auctionDescription,
                              initialPrice: buyoutPriceValue,
                              currentPrice: buyoutPriceValue,
                              startDate: Date(),
                              endDate: auctionEndDate,
                              auctionType: auctionType,
                              auctionItemType: auctionItemType,
                              buyoutPrice: buyoutPriceValue,
                              decrementAmount: decrementAmountValue,
                              decrementInterval: decrementIntervalValue * 60,
                              floorPrice: floorPriceValue)
        } else {
            auction = Auction(id: UUID().uuidString,
                              title: auctionTitle,
                              description: auctionDescription,
                              initialPrice: currentBidValue,
                              currentPrice: currentBidValue,
                              startDate: Date(),
                              endDate: auctionEndDate,
                              auctionType: auctionType,
                              auctionItemType: auctionItemType)
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
            
            if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
                let fileURL = documentDirectory.appendingPathComponent("auctions.json")
                
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    var existingData = try Data(contentsOf: fileURL)
                    existingData.append(",\n".data(using: .utf8)!)
                    existingData.append(jsonData)
                    try existingData.write(to: fileURL)
                } else {
                    let jsonArray = "[\n" + jsonString + "\n]"
                    try jsonArray.write(to: fileURL, atomically: true, encoding: .utf8)
                }
                
                print("Auction added to JSON file successfully!")
            }
        } catch {
            print("Error encoding auction: \(error.localizedDescription)")
        }
    }
}
