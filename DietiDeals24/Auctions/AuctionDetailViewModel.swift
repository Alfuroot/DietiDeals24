import SwiftUI
import UserNotifications

class AuctionDetailViewModel: ObservableObject {
    @Published var auctionItem: AuctionItem
    @Published var bidAmount: String = ""
    @Published var alertMessage: AlertMessage?
    
    init(auctionItem: AuctionItem) {
        self.auctionItem = auctionItem
    }
    
    var formattedCurrentBid: String {
        auctionItem.currentBid ?? "N/A"
    }
    
    var formattedBidEndDate: String {
        guard let bidEndDate = auctionItem.bidEndDate else { return "N/A" }
        return formatDate(bidEndDate)
    }
    
    func isReverseAuction() -> Bool {
        return auctionItem.auctionType == .reverse
    }
    
    private func formatDate(_ dateString: String) -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: dateString) else { return "Invalid Date" }
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
        
        guard let cleanCurrentBidString = auctionItem.currentBid?
            .replacingOccurrences(of: "€", with: "")
            .replacingOccurrences(of: "$", with: "")
            .trimmingCharacters(in: .whitespaces),
              let currentBid = Double(cleanCurrentBidString),
              let newBid = Double(bidAmount.replacingOccurrences(of: ",", with: ".")) else {
            showAlert(message: "Invalid bid format.")
            return
        }
        
        // Check if the new bid is higher than the current bid
        guard newBid > currentBid else {
            showAlert(message: "Your bid must be higher than the current bid.")
            return
        }
        
        // If validation passes, proceed to place the bid
        placeBid(auctionId: auctionItem.id, bidAmount: newBid)
        showAlert(message: "Your bid of $\(String(format: "%.2f", newBid)) has been placed!")
        bidAmount = ""
    }
    
    private func showAlert(message: String) {
        alertMessage = AlertMessage(message: message)
    }
    
    private func placeBid(auctionId: String, bidAmount: Double) {
        scheduleBidNotification(for: auctionId, bidAmount: bidAmount)
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
