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

class AuctionItem: Codable, Identifiable, Hashable {
    var id: String
    var title: String
    var description: String
    var imageUrl: String?
    var category: AuctionItemType
    
    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         imageUrl: String? = nil,
         category: AuctionItemType) {
        self.id = id
        self.title = title
        self.description = description
        self.imageUrl = imageUrl
        self.category = category
    }

    // Conformance to Hashable
    static func == (lhs: AuctionItem, rhs: AuctionItem) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(imageUrl)
        hasher.combine(category)
    }
}

class Auction: Codable, Hashable {
    var id: String
    var title: String
    var description: String
    var initialPrice: Float
    var currentPrice: Float
    var startDate: Date
    var endDate: Date
    var auctionType: AuctionType
    var auctionItem: AuctionItem
    var buyoutPrice: Float?
    var decrementAmount: Float?
    var decrementInterval: TimeInterval?
    var floorPrice: Float?
    var sellerID: String
    
    init(id: String = UUID().uuidString,
         title: String,
         description: String,
         initialPrice: Float,
         currentPrice: Float,
         startDate: Date,
         endDate: Date,
         auctionType: AuctionType,
         auctionItem: AuctionItem,
         sellerID: String,
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
        self.auctionType = auctionType
        self.auctionItem = auctionItem
        self.sellerID = sellerID
        self.buyoutPrice = buyoutPrice
        self.decrementAmount = decrementAmount
        self.decrementInterval = decrementInterval
        self.floorPrice = floorPrice
    }

    enum CodingKeys: String, CodingKey {
        case id, title, description, initialPrice, currentPrice, startDate, endDate, auctionType, auctionItem, buyoutPrice, decrementAmount, decrementInterval, floorPrice, sellerID // Add sellerID to CodingKeys
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        initialPrice = try container.decode(Float.self, forKey: .initialPrice)
        currentPrice = try container.decode(Float.self, forKey: .currentPrice)
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        let endDateString = try container.decode(String.self, forKey: .endDate)
        
        let dateFormatter = ISO8601DateFormatter()
        startDate = dateFormatter.date(from: startDateString) ?? Date()
        endDate = dateFormatter.date(from: endDateString) ?? Date()

        auctionType = try container.decode(AuctionType.self, forKey: .auctionType)
        auctionItem = try container.decode(AuctionItem.self, forKey: .auctionItem)
        buyoutPrice = try container.decodeIfPresent(Float.self, forKey: .buyoutPrice)
        decrementAmount = try container.decodeIfPresent(Float.self, forKey: .decrementAmount)
        decrementInterval = try container.decodeIfPresent(TimeInterval.self, forKey: .decrementInterval)
        floorPrice = try container.decodeIfPresent(Float.self, forKey: .floorPrice)
        sellerID = try container.decode(String.self, forKey: .sellerID) // Decode sellerID
    }

    func isAuctionActive() -> Bool {
        return Date() < endDate
    }

    func getRemainingTime() -> TimeInterval {
        return endDate.timeIntervalSince(Date())
    }

    static func == (lhs: Auction, rhs: Auction) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(initialPrice)
        hasher.combine(currentPrice)
        hasher.combine(startDate)
        hasher.combine(endDate)
        hasher.combine(auctionType)
        hasher.combine(auctionItem)
        hasher.combine(buyoutPrice)
        hasher.combine(decrementAmount)
        hasher.combine(decrementInterval)
        hasher.combine(floorPrice)
        hasher.combine(sellerID)
    }
}

class Bid: Codable, Hashable {
    var auctionID: String
    var bidderID: String
    var amount: Float
    var timestamp: Date

    init(auctionID: String, bidderID: String, amount: Float, timestamp: Date = Date()) {
        self.auctionID = auctionID
        self.bidderID = bidderID
        self.amount = amount
        self.timestamp = timestamp
    }

    static func == (lhs: Bid, rhs: Bid) -> Bool {
        return lhs.auctionID == rhs.auctionID && lhs.bidderID == rhs.bidderID && lhs.amount == rhs.amount && lhs.timestamp == rhs.timestamp
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(auctionID)
        hasher.combine(bidderID)
        hasher.combine(amount)
        hasher.combine(timestamp)
    }
}
