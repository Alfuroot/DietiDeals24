import Foundation

// Enum to define the status of an auction
enum AuctionStatus: String, Codable {
    case active
    case ended
    case cancelled
}

// Enum to define the type of auction
enum AuctionType: String, CaseIterable, Codable {
    case classic
    case reverse
}

// Auction Model to represent an auction
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
    var buyoutPrice: Float? // Applicable for reverse auctions
    var decrementAmount: Float? // Amount it decreases by in reverse auctions
    var decrementInterval: TimeInterval? // Interval in seconds for decrement in reverse auctions
    var floorPrice: Float? // The minimum price for reverse auctions
    
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

// Bid Model to represent a bid placed on an auction
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
