import SwiftUI

struct AddAuctionView: View {
    @State private var auctionTitle: String = ""
    @State private var auctionDescription: String = ""
    @State private var auctionType: AuctionType = .classic
    @State private var auctionImageURL: String = ""
    @State private var auctionCurrentBid: String = ""
    
    @State private var buyoutPrice: String = ""
    @State private var decrementAmount: String = ""
    @State private var decrementInterval: String = ""
    @State private var floorPrice: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Auction Details")) {
                    TextField("Title", text: $auctionTitle)
                    TextField("Description", text: $auctionDescription)
                    TextField("Image URL", text: $auctionImageURL)
                    TextField("Current Bid", text: $auctionCurrentBid)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Auction Type")) {
                    Picker("Auction Type", selection: $auctionType) {
                        ForEach(AuctionType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                if auctionType == .reverse {
                    Section(header: Text("Reverse Auction Details")) {
                        TextField("Buyout Price", text: $buyoutPrice)
                            .keyboardType(.decimalPad)
                        TextField("Decrement Amount", text: $decrementAmount)
                            .keyboardType(.decimalPad)
                        TextField("Decrement Interval (minutes)", text: $decrementInterval)
                            .keyboardType(.decimalPad)
                        TextField("Floor Price", text: $floorPrice)
                            .keyboardType(.decimalPad)
                    }
                }

                Button("Add Auction") {
                    addAuction()
                }
            }
            .navigationTitle("Add Auction")
        }
    }

    private func addAuction() {
        guard let currentBidValue = Float(auctionCurrentBid),
              let buyoutPriceValue = auctionType == .reverse ? Float(buyoutPrice) : nil,
              let decrementAmountValue = auctionType == .reverse ? Float(decrementAmount) : nil,
              let decrementIntervalValue = auctionType == .reverse ? TimeInterval(decrementInterval) : nil,
              let floorPriceValue = auctionType == .reverse ? Float(floorPrice) : nil else {
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
                              endDate: Date().addingTimeInterval(3600), // Example: 1 hour from now
                              auctionType: auctionType,
                              buyoutPrice: buyoutPriceValue,
                              decrementAmount: decrementAmountValue,
                              decrementInterval: decrementIntervalValue * 60, // Convert minutes to seconds
                              floorPrice: floorPriceValue)
        } else {
            auction = Auction(id: UUID().uuidString,
                              title: auctionTitle,
                              description: auctionDescription,
                              initialPrice: currentBidValue,
                              currentPrice: currentBidValue,
                              startDate: Date(),
                              endDate: Date().addingTimeInterval(3600), // Example: 1 hour from now
                              auctionType: auctionType)
        }

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

struct AddAuctionView_Previews: PreviewProvider {
    static var previews: some View {
        AddAuctionView()
    }
}
