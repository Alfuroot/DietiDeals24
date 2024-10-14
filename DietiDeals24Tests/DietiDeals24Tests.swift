//
//  DietiDeals24Tests.swift
//  DietiDeals24Tests
//
//  Created by Giuseppe Carannante on 26/11/23.
//

import XCTest
@testable import DietiDeals24
import UserNotifications

class AuctionTests: XCTestCase {
    
    var auctionItem: AuctionItem!
    var alertMessage: AlertMessage?
    var bidAmount: String!
    
    override func setUpWithError() throws {
        // Initialize test variables
        auctionItem = AuctionItem(id: "1111111", title: "TestTitle", description: "TestDes", imageUrl: nil, currentBid: "100", bidEndDate: nil, userBid: nil, auctionStatus: nil, isSeller: false)
        bidAmount = "150.00" // New bid for testing
    }

    override func tearDownWithError() throws {
        // Reset state
        auctionItem = nil
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
            XCTAssertEqual(request.identifier, identifier, "Notification identifier should match")
        }
    }

    func testPlaceBid() {
        auctionItem.currentBid = "$100.00"
        bidAmount = "150.00"
        
        // Clean and parse current bid
        let currencySymbols = CharacterSet(charactersIn: "€$").union(.punctuationCharacters)
        let cleanCurrentBidString = auctionItem.currentBid?
            .trimmingCharacters(in: currencySymbols)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let currentBidString = cleanCurrentBidString,
              let currentBid = Double(currentBidString),
              let newBid = Double(bidAmount) else {
            XCTFail("Bid parsing failed")
            return
        }
        
        XCTAssertTrue(newBid > currentBid, "New bid should be higher than the current bid")
    }
    
    func testValidIBAN() {
        let validator = Validator()
        // Valid IBAN (Italy example)
        let validIBAN = "IT60X0542811101000000123456"
        XCTAssertTrue(validator.isValidIBAN(validIBAN), "The IBAN should be valid")
        
        // Invalid IBAN (wrong length)
        let invalidIBANLength = "IT60X054281110100000012378787878787878787878787878787"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANLength), "The IBAN should be invalid due to length")
        
        // Invalid IBAN (contains special characters)
        let invalidIBANSpecialChars = "IT60X05428-11101000000123456"
        XCTAssertFalse(validator.isValidIBAN(invalidIBANSpecialChars), "The IBAN should be invalid due to special characters")
    }

}
