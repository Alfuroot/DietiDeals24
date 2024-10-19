import SwiftUI
import UserNotifications

class AuctionDetailViewModel: ObservableObject {
    @Published var auction: Auction
    @Published var bidAmount: String = ""
    @Published var alertMessage: AlertMessage?
    
    init(auction: Auction) {
        self.auction = auction
    }
    
    var formattedCurrentBid: String {
        "\(auction.currentPrice)"  // Using currentPrice from the Auction class
    }
    
    var formattedBidEndDate: String {
        return formatDate(auction.endDate)  // endDate is a Date object
    }
    
    func isReverseAuction() -> Bool {
        return auction.auctionType == .reverse
    }
    
    private func formatDate(_ date: Date) -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateStyle = .medium
        outputFormatter.timeStyle = .short
        return outputFormatter.string(from: date)
    }
    
    
    func placeBid() {
        guard !bidAmount.isEmpty else {
            showAlert(message: "Bid amount cannot be empty.")
            return
        }
        
        guard let newBid = Double(bidAmount.replacingOccurrences(of: ",", with: ".")) else {
            showAlert(message: "Invalid bid format.")
            return
        }
        
        guard newBid > Double(auction.currentPrice) else {
            showAlert(message: "Your bid must be higher than the current bid.")
            return
        }
        
        placeBid(auctionId: auction.id, bidAmount: newBid)
        showAlert(message: "Your bid of $\(String(format: "%.2f", newBid)) has been placed!")
        bidAmount = ""
    }
    
    private func showAlert(message: String) {
        alertMessage = AlertMessage(message: message)
    }
    
    private func placeBid(auctionId: String, bidAmount: Double) {
        scheduleBidNotification(for: auctionId, bidAmount: bidAmount)
    }
    
    func buyout() {
            guard let buyoutPrice = auction.buyoutPrice else {
                showAlert(message: "This auction does not have a buyout price.")
                return
            }
        if userCanAfford(buyoutPrice: Double(buyoutPrice)) {
            executeBuyout(auctionId: auction.id, buyoutPrice: Double(buyoutPrice))
                showAlert(message: "You have purchased the auction item for $\(String(format: "%.2f", buyoutPrice)).")
            } else {
                showAlert(message: "You cannot afford this buyout price.")
            }
        }
        
        private func userCanAfford(buyoutPrice: Double) -> Bool {
            // Implement logic to check if the user can afford the buyout price.
            // For example, check against user's balance
            return true  // Change this to your actual balance check
        }

        private func executeBuyout(auctionId: String, buyoutPrice: Double) {
            // Implement the logic to execute the buyout in your backend or state management
            scheduleBuyoutNotification(for: auctionId, buyoutPrice: buyoutPrice)
        }
        
        private func scheduleBuyoutNotification(for auctionId: String, buyoutPrice: Double) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
                if granted {
                    self.createBuyoutNotification(auctionId: auctionId, buyoutPrice: buyoutPrice)
                } else if let error = error {
                    print("Error requesting notification permission: \(error.localizedDescription)")
                }
            }
        }
        
        private func createBuyoutNotification(auctionId: String, buyoutPrice: Double) {
            let content = UNMutableNotificationContent()
            content.title = "Auction Purchased!"
            content.body = "You bought the auction item for $\(String(format: "%.2f", buyoutPrice))."
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let identifier = "BuyoutPurchased-\(auctionId)"
            
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Buyout notification scheduled for auction \(auctionId) with price \(buyoutPrice).")
                }
            }
        }
    
    private func scheduleBidNotification(for auctionId: String, bidAmount: Double) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.createBidNotification(auctionId: auctionId, bidAmount: bidAmount)
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }
    
    private func createBidNotification(auctionId: String, bidAmount: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Bid Placed!"
        content.body = "You placed a bid of $\(String(format: "%.2f", bidAmount)) on auction \(auctionId)."
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let identifier = "BidPlaced-\(auctionId)"
        
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for auction \(auctionId) with bid amount \(bidAmount).")
            }
        }
    }
}
