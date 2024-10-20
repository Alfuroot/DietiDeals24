import XCTest
@testable import DietiDeals24
import UserNotifications

//class MockNotificationCenter: UNUserNotificationCenter {
//    var didRequestAuthorization = false
//    var lastNotificationContent: UNMutableNotificationContent?
//
//    override func requestAuthorization(options: UNAuthorizationOptions, completionHandler: @escaping (Bool, Error?) -> Void) {
//        didRequestAuthorization = true
//        completionHandler(true, nil)
//    }
//    
//    init(didRequestAuthorization: Bool = false, lastNotificationContent: UNMutableNotificationContent? = nil) {
//        self.didRequestAuthorization = didRequestAuthorization
//        self.lastNotificationContent = lastNotificationContent
//    }
//}

class MockNotificationCenterWithError: UNUserNotificationCenter {
    var simulateError: Bool = false
    var lastRequest: UNNotificationRequest?
    
    override func add(_ request: UNNotificationRequest, withCompletionHandler completionHandler: ((Error?) -> Void)?) {
        lastRequest = request
        
        if simulateError {
            let error = NSError(domain: "com.example.notification", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to schedule notification"])
            completionHandler?(error)
        } else {
            completionHandler?(nil)
        }
    }
}


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
    
//    func testScheduleBidNotificationNotValid() {
//           
//            let mockNotificationCenter = MockNotificationCenter(didRequestAuthorization: false)
//            
//            let expectation = self.expectation(description: "Notification permission denied")
//
//            // Use the mock notification center to simulate permission denial
//            mockNotificationCenter.requestAuthorization(options: [.alert, .sound]) { granted, error in
//                XCTAssertFalse(granted, "Notification permission should NOT be granted")
//                XCTAssertNil(error, "There should be no error when denying permission")
//                expectation.fulfill()
//            }
//            
//            waitForExpectations(timeout: 1, handler: nil)
//        }
    
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
    
//    func testCreateBidNotificationWithError() {
//        let auctionId = "12345"
//        let bidAmount = 150.00
//        
//        let content = UNMutableNotificationContent()
//        content.title = "Bid Placed!"
//        content.body = "You placed a bid of $\(bidAmount) on auction \(auctionId)."
//        content.sound = UNNotificationSound.default
//        
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
//        let identifier = "BidPlaced-\(auctionId)"
//        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
//        
//        let mockNotificationCenter = MockNotificationCenterWithError()
//        mockNotificationCenter.simulateError = true
//        
//        let expectation = self.expectation(description: "Notification scheduling should fail with an error")
//        
//        mockNotificationCenter.add(request) { error in
//            XCTAssertNotNil(error, "An error should occur when scheduling the notification")
//            XCTAssertEqual((error! as NSError).localizedDescription, "Failed to schedule notification", "Error message should match")
//            XCTAssertEqual(mockNotificationCenter.lastRequest?.identifier, identifier, "Notification identifier should match")
//            expectation.fulfill()
//        }
//        
//        waitForExpectations(timeout: 1, handler: nil)
//    }

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

    func testPlaceBidWithErrors() {
        auction.currentPrice = 100.00

        bidAmount = "invalidBidAmount"
        
        if let invalidBid = Double(bidAmount) {
            XCTFail("Bid parsing should have failed for non-numeric bid amount.")
        } else {
            XCTAssert(true, "Bid parsing correctly failed for non-numeric input.")
        }
        
        bidAmount = ""
        
        if let emptyBid = Double(bidAmount) {
            XCTFail("Bid parsing should have failed for empty bid input.")
        } else {
            XCTAssert(true, "Bid parsing correctly failed for empty input.")
        }
        
        bidAmount = "50.00"
        let cleanCurrentBidString = String(auction.currentPrice)
            .trimmingCharacters(in: .punctuationCharacters)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let currentBid = Double(cleanCurrentBidString),
              let lowBid = Double(bidAmount) else {
            XCTFail("Bid parsing failed for lower bid.")
            return
        }
        
        XCTAssertFalse(lowBid > currentBid, "Bid should not be accepted when it is lower than the current bid.")
        
        bidAmount = "100.00"
        guard let equalBid = Double(bidAmount) else {
            XCTFail("Bid parsing failed for equal bid.")
            return
        }
        
        XCTAssertFalse(equalBid > currentBid, "Bid should not be accepted when it is exactly equal to the current price.")
    }

    func testAuctionStatus() {
        let auctionEndDate = Date().addingTimeInterval(600)
        auction.endDate = auctionEndDate
        
        XCTAssertTrue(auction.isAuctionActive(), "The auction should be active since the end date is in the future")
        
        auction.endDate = Date().addingTimeInterval(-100)
        XCTAssertFalse(auction.isAuctionActive(), "The auction should be inactive since the end date is in the past")
    }
    
    func testValidIBANWithErrors() {
        let validator = Validator()
        
        let validIBAN = "IT60X0542811101000000123456"
        XCTAssertTrue(validator.isValidIBAN(validIBAN), "The IBAN should be valid")
        
        let invalidIBANLengthLong = "IT60X054281110100000012378787878787878787878787878787"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANLengthLong), "The IBAN should be invalid due to excessive length")
        
        let invalidIBANLengthShort = "IT60X054201"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANLengthShort), "The IBAN should be invalid due to insufficient length")
        
        let invalidIBANSpecialChars = "IT60X05428-11101000000123456"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANSpecialChars), "The IBAN should be invalid due to special characters")
        
        let invalidIBANLettersInNumber = "IT60X0542811101000000ABCDEF"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANLettersInNumber), "The IBAN should be invalid due to letters in the numeric part")
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
