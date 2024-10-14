import Foundation

enum AuctionStatus: String, Codable {
    case active
    case ended
    case failed
}

enum AuctionType: String, CaseIterable, Codable {
    case classic
    case reverse
}

enum AuctionItemType: String, CaseIterable, Codable, Hashable, Comparable {
    case tecnologia = "Tecnologia"
    case casa = "Casa"
    case moda = "Moda"
    case auto = "Automobili"
    case moto = "Moto"
    case libri = "Libri"
    case giochi = "Giochi"
    case videogiochi = "Videogiochi"
    case altri = "Altri"

    static func < (lhs: AuctionItemType, rhs: AuctionItemType) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    var displayName: String {
        return self.rawValue
    }
}

class Auction: Codable {
    var id: String
    var title: String
    var description: String
    var initialPrice: Float
    var currentPrice: Float
    var startDate: Date
    var endDate: Date
    var status: AuctionStatus
    var bids: [Bid]
    var auctionType: AuctionType
    var auctionItemType: AuctionItemType
    var buyoutPrice: Float?
    var decrementAmount: Float?
    var decrementInterval: TimeInterval?
    var floorPrice: Float?
    
    init(id: String,
         title: String,
         description: String,
         initialPrice: Float,
         currentPrice: Float,
         startDate: Date,
         endDate: Date,
         status: AuctionStatus = .active,
         bids: [Bid] = [],
         auctionType: AuctionType,
         auctionItemType: AuctionItemType,
         buyoutPrice: Float? = nil,
         decrementAmount: Float? = nil,
         decrementInterval: TimeInterval? = nil,
         floorPrice: Float? = nil) {
        
        self.id = id
        self.title = title
        self.description = description
        self.initialPrice = initialPrice
        self.currentPrice = currentPrice
        self.startDate = startDate
        self.endDate = endDate
        self.status = status
        self.bids = bids
        self.auctionType = auctionType
        self.auctionItemType = auctionItemType
        self.buyoutPrice = buyoutPrice
        self.decrementAmount = decrementAmount
        self.decrementInterval = decrementInterval
        self.floorPrice = floorPrice
    }
    
    func isAuctionActive() -> Bool {
        return status == .active && Date() < endDate
    }
    
    func placeBid(bid: Bid) {
        if isAuctionActive() {
            bids.append(bid)
            currentPrice = bid.amount
        }
    }
    
    func decrementCurrentPrice() {
        guard auctionType == .reverse,
              let decrementAmount = decrementAmount,
              let floorPrice = floorPrice,
              currentPrice - decrementAmount >= floorPrice else { return }
        
        currentPrice -= decrementAmount
    }
    
    func getRemainingTime() -> TimeInterval {
        return endDate.timeIntervalSince(Date())
    }
}

class Bid: Codable {
    
    var bidderID: String
    var amount: Float
    var timestamp: Date
    
    init(bidderID: String, amount: Float, timestamp: Date = Date()) {
        self.bidderID = bidderID
        self.amount = amount
        self.timestamp = timestamp
    }
}
