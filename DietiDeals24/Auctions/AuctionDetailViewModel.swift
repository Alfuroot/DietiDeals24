import SwiftUI
import UserNotifications

@MainActor
class AuctionDetailViewModel: ObservableObject {
    @Published var auction: Auction
    @Published var bidAmount: String = ""
    @Published var alertMessage: AlertMessage?
    private var dataLoader = DataLoader()
    
    var isAuctionActive: Bool {
            return Date() < auction.endDate
        }
    init(auction: Auction) {
        self.auction = auction
    }
    
    var formattedCurrentBid: String {
        String(format: "%.2f", auction.currentPrice)
    }
    
    var formattedBidEndDate: String {
        return formatDate(auction.endDate)
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
        Task {
            guard !bidAmount.isEmpty else {
                showAlert(message: "Bid amount cannot be empty.")
                return
            }
            
            guard let newBidAmount = Double(bidAmount.replacingOccurrences(of: ",", with: ".")) else {
                showAlert(message: "Invalid bid format.")
                return
            }
            
            guard newBidAmount > Double(auction.currentPrice) else {
                showAlert(message: "Your bid must be higher than the current bid.")
                return
            }
            
            let bid = Bid(auctionID: auction.id, bidderID: User.shared.id, amount: Float(newBidAmount), timestamp: Date())
            do {
                try await dataLoader.placeBid(auctionId: auction.id, bid: bid)
                showAlert(message: "Your bid of $\(String(format: "%.2f", newBidAmount)) has been placed!")
                self.bidAmount = ""
                self.auction.currentPrice = Float(newBidAmount)
            } catch {
                showAlert(message: "Failed to place bid: \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(message: String) {
        alertMessage = AlertMessage(message: message)
    }
    
    func buyout() async {
        guard let buyoutPrice = auction.buyoutPrice else {
            showAlert(message: "This auction does not have a buyout price.")
            return
        }
        if userCanAfford(buyoutPrice: Double(auction.calculatedReversePrice)) {
            do {
                       try await dataLoader.buyoutAuction(auctionId: auction.id)
                       showAlert(message: "You have purchased the auction item for $\(String(format: "%.2f", auction.calculatedReversePrice)).")
                        await dataLoader.loadRemoteData()
                       
                   } catch {
                       showAlert(message: "An error occurred while attempting to buy out the auction: \(error.localizedDescription)")
                   }
        } else {
            showAlert(message: "You cannot afford this buyout price.")
        }
    }
    
    private func userCanAfford(buyoutPrice: Double) -> Bool {
        return true
    }
    
    private func executeBuyout(auctionId: String, buyoutPrice: Double) {
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
    
    func scheduleBidNotification(for auctionId: String, bidAmount: Double) async {
        do {
            let granted = try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
            if granted {
                createBidNotification(auctionId: auctionId, bidAmount: bidAmount)
            } else {
                print("Notification permission not granted.")
            }
        } catch {
            print("Error requesting notification permission: \(error.localizedDescription)")
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
