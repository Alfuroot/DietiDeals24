import XCTest
@testable import DietiDeals24
import UserNotifications

class AuctionTests: XCTestCase {
    
    var auctionItem: AuctionItem!
    var auction: Auction!
    var alertMessage: AlertMessage?
    var bidAmount: String!

    override func setUpWithError() throws {
        auctionItem = AuctionItem(id: "1111111", title: "TestTitle", description: "TestDescription", imageUrl: nil, category: .tecnologia)
        auction = Auction(title: "Test Auction", description: "Auction for testing", initialPrice: 100.0, currentPrice: 100.0, startDate: Date(), endDate: Date().addingTimeInterval(600), auctionType: .classic, auctionItem: auctionItem, sellerID: "1111111", buyoutPrice: 200.0)
        bidAmount = "150.00"
    }

    override func tearDownWithError() throws {
        auctionItem = nil
        auction = nil
        alertMessage = nil
    }

    func testScheduleBidNotification() {
        let expectation = self.expectation(description: "Notification permission requested")
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            XCTAssertTrue(granted, "Notification permission should be granted")
            XCTAssertNil(error, "There should be no error in requesting permission")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testScheduleBidNotificationNotValid() {
        let expectation = self.expectation(description: "Notification permission requested")
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
            XCTAssertFalse(granted, "Notification permission should be granted")
            XCTAssertNotNil(error, "There should be no error in requesting permission")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCreateBidNotification() {
        let auctionId = "12345"
        let bidAmount = 150.00
        
        let content = UNMutableNotificationContent()
        content.title = "Bid Placed!"
        content.body = "You placed a bid of $\(bidAmount) on auction \(auctionId)."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "BidPlaced-\(auctionId)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            XCTAssertNil(error, "Error scheduling notification should be nil")
        }
        
        XCTAssertEqual(request.identifier, identifier, "Notification identifier should match")
    }

    func testPlaceBid() {
        auction.currentPrice = 100.00
        bidAmount = "150.00"
        
        let currencySymbols = CharacterSet(charactersIn: "€$").union(.punctuationCharacters)
        let cleanCurrentBidString = String(auction.currentPrice)
            .trimmingCharacters(in: currencySymbols)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let currentBid = Double(cleanCurrentBidString),
              let newBid = Double(bidAmount) else {
            XCTFail("Bid parsing failed")
            return
        }
        
        XCTAssertEqual(auction.currentPrice, 100.00, "Current price should be initially set to 100.00")
        
        XCTAssertTrue(newBid > currentBid, "New bid should be higher than the current bid")
        XCTAssertEqual(newBid, 150.00, "The new bid amount should be 150.00 after conversion")
        auction.currentPrice = Float(newBid)
        XCTAssertEqual(auction.currentPrice, 150.00, "Current price should be updated to the new bid amount after placement")
    }

    
    func testAuctionStatus() {
        let auctionEndDate = Date().addingTimeInterval(600)
        auction.endDate = auctionEndDate
        
        XCTAssertTrue(auction.isAuctionActive(), "The auction should be active since the end date is in the future")
        
        auction.endDate = Date().addingTimeInterval(-100)
        XCTAssertFalse(auction.isAuctionActive(), "The auction should be inactive since the end date is in the past")
    }
    
    func testValidIBAN() {
        let validator = Validator()
        
        let validIBAN = "IT60X0542811101000000123456"
        XCTAssertTrue(validator.isValidIBAN(validIBAN), "The IBAN should be valid")
        
        let invalidIBANLength = "IT60X054281110100000012378787878787878787878787878787"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANLength), "The IBAN should be invalid due to incorrect length")
        
        let invalidIBANSpecialChars = "IT60X05428-11101000000123456"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANSpecialChars), "The IBAN should be invalid due to special characters")
    }
    
    func testAuctionType() {
        XCTAssertEqual(auction.auctionType, .classic, "Auction type should be 'classic' by default")
        
        let reverseAuction = Auction(title: "Reverse Auction", description: "Reverse auction test", initialPrice: 1000.0, currentPrice: 1000.0, startDate: Date(), endDate: Date().addingTimeInterval(3600), auctionType: .reverse, auctionItem: auctionItem, sellerID: "111111", decrementAmount: 10.0, decrementInterval: 60.0, floorPrice: 800.0)
        
        XCTAssertEqual(reverseAuction.auctionType, .reverse, "Auction type should be 'reverse'")
        XCTAssertNotNil(reverseAuction.decrementAmount, "Decrement amount should not be nil for reverse auction")
        XCTAssertEqual(reverseAuction.decrementAmount, 10.0, "Decrement amount should match the provided value")
        XCTAssertEqual(reverseAuction.floorPrice, 800.0, "Floor price should match the provided value")
    }
}
