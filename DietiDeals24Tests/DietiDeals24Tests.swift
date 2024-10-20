import XCTest
@testable import DietiDeals24
import UserNotifications

class AuctionTests: XCTestCase {
    
    var auctionItem: AuctionItem!
    var auction: Auction!
    var alertMessage: AlertMessage?
    var bidAmount: String!

    override func setUpWithError() throws {
        // Initialize test variables
        auctionItem = AuctionItem(id: "1111111", title: "TestTitle", description: "TestDescription", imageUrl: nil, category: .tecnologia)
        auction = Auction(title: "Test Auction", description: "Auction for testing", initialPrice: 100.0, currentPrice: 100.0, startDate: Date(), endDate: Date().addingTimeInterval(600), auctionType: .classic, auctionItem: auctionItem, buyoutPrice: 200.0)
        bidAmount = "150.00" // New bid for testing
    }

    override func tearDownWithError() throws {
        // Reset state
        auctionItem = nil
        auction = nil
        alertMessage = nil
    }

    // Test scheduling of bid notification permission request
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
    
    // Test creation of a bid notification
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

    // Test placing a bid that is higher than the current bid
    func testPlaceBid() {
        auction.currentPrice = 100.00
        bidAmount = "150.00"
        
        // Clean and parse current bid
        let currencySymbols = CharacterSet(charactersIn: "€$").union(.punctuationCharacters)
        let cleanCurrentBidString = String(auction.currentPrice)
            .trimmingCharacters(in: currencySymbols)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let currentBid = Double(cleanCurrentBidString),
              let newBid = Double(bidAmount) else {
            XCTFail("Bid parsing failed")
            return
        }
        
        XCTAssertTrue(newBid > currentBid, "New bid should be higher than the current bid")
    }
    
    // Test auction status - isAuctionActive
    func testAuctionStatus() {
        // Set up the auction with an end date in the future
        let auctionEndDate = Date().addingTimeInterval(600)
        auction.endDate = auctionEndDate
        
        XCTAssertTrue(auction.isAuctionActive(), "The auction should be active since the end date is in the future")
        
        // Simulate an auction that has ended
        auction.endDate = Date().addingTimeInterval(-100)
        XCTAssertFalse(auction.isAuctionActive(), "The auction should be inactive since the end date is in the past")
    }
    
    // Test IBAN validation logic for different cases
    func testValidIBAN() {
        let validator = Validator()
        
        // Valid IBAN (Italy example)
        let validIBAN = "IT60X0542811101000000123456"
        XCTAssertTrue(validator.isValidIBAN(validIBAN), "The IBAN should be valid")
        
        // Invalid IBAN (wrong length)
        let invalidIBANLength = "IT60X054281110100000012378787878787878787878787878787"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANLength), "The IBAN should be invalid due to incorrect length")
        
        // Invalid IBAN (contains special characters)
        let invalidIBANSpecialChars = "IT60X05428-11101000000123456"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANSpecialChars), "The IBAN should be invalid due to special characters")
    }
    
    // Test auction types (classic, reverse)
    func testAuctionType() {
        // Test classic auction
        XCTAssertEqual(auction.auctionType, .classic, "Auction type should be 'classic' by default")
        
        // Test reverse auction setup
        let reverseAuction = Auction(title: "Reverse Auction", description: "Reverse auction test", initialPrice: 1000.0, currentPrice: 1000.0, startDate: Date(), endDate: Date().addingTimeInterval(3600), auctionType: .reverse, auctionItem: auctionItem, decrementAmount: 10.0, decrementInterval: 60.0, floorPrice: 800.0)
        
        XCTAssertEqual(reverseAuction.auctionType, .reverse, "Auction type should be 'reverse'")
        XCTAssertNotNil(reverseAuction.decrementAmount, "Decrement amount should not be nil for reverse auction")
        XCTAssertEqual(reverseAuction.decrementAmount, 10.0, "Decrement amount should match the provided value")
        XCTAssertEqual(reverseAuction.floorPrice, 800.0, "Floor price should match the provided value")
    }
}
