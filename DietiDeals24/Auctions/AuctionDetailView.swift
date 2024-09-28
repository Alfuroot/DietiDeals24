import SwiftUI

struct AlertMessage: Identifiable {
    var id: UUID = UUID()
    var message: String
}

struct AuctionDetailView: View {
    var auctionItem: AuctionItem
    @State private var bidAmount: String = ""
    @State private var alertMessage: AlertMessage?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = auctionItem.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .failure:
                            Image(systemName: "exclamationmark.icloud")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .empty:
                            ProgressView()
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(height: 250)
                }

                Text(auctionItem.title ?? "No Title")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(auctionItem.description ?? "No Description")
                    .font(.body)

                Text("Current Bid: \(auctionItem.currentBid ?? "N/A")")
                    .font(.headline)

                Text("Bid End Date: \(auctionItem.bidEndDate ?? "N/A")")
                    .font(.headline)
                    .foregroundColor(.gray)

                TextField("Enter your bid amount", text: $bidAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                Button(action: placeBid) {
                    Text("Place Bid")
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(item: $alertMessage) { alertMessage in
                    Alert(title: Text("Bid Status"), message: Text(alertMessage.message), dismissButton: .default(Text("OK")))
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Auction Details")
    }

    private func placeBid() {
        print("Current Bid String: \(String(describing: auctionItem.currentBid))")
        print("New Bid Amount: \(bidAmount)")

        let currencySymbols = CharacterSet(charactersIn: "€$").union(.punctuationCharacters)
        let cleanCurrentBidString = auctionItem.currentBid?
            .trimmingCharacters(in: currencySymbols)
            .replacingOccurrences(of: ",", with: ".")
        
        guard let currentBidString = cleanCurrentBidString,
              let currentBid = Double(currentBidString),
              let newBid = Double(bidAmount) else {
            alertMessage = AlertMessage(message: "Invalid bid format.")
            return
        }

        print("Current Bid: \(currentBid), New Bid: \(newBid)")

        // Check if the new bid is higher than the current bid
        guard newBid > currentBid else {
            alertMessage = AlertMessage(message: "Your bid must be higher than the current bid.")
            return
        }

        // If validation passes, proceed to place the bid
        placeBid(auctionId: auctionItem.id, bidAmount: newBid)
        
        // Notify user of successful bid placement
        alertMessage = AlertMessage(message: "Your bid of $\(newBid) has been placed!")
        bidAmount = ""
    }

    private func placeBid(auctionId: String, bidAmount: Double) {
        scheduleBidNotification(for: auctionId, bidAmount: bidAmount)
    }
    
    private func scheduleBidNotification(for auctionId: String, bidAmount: Double) {
        // Request notification permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.createBidNotification(auctionId: auctionId, bidAmount: bidAmount)
            } else if let error = error {
                print("Error requesting notification permission: \(error.localizedDescription)")
            }
        }
    }

    private func createBidNotification(auctionId: String, bidAmount: Double) {
        // Create the content of the notification
        let content = UNMutableNotificationContent()
        content.title = "Bid Placed!"
        content.body = "You placed a bid of $\(bidAmount) on auction \(auctionId)."
        content.sound = UNNotificationSound.default
        
        // Create a trigger to fire the notification immediately
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // Create a unique identifier for the notification
        let identifier = "BidPlaced-\(auctionId)"
        
        // Create the request
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for auction \(auctionId) with bid amount \(bidAmount).")
            }
        }
    }
}

struct AuctionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionDetailView(auctionItem: AuctionItem(id: "1", title: "Sample Item", description: "Sample Description", imageUrl: "https://example.com/sample.jpg", currentBid: "$100", bidEndDate: "2024-10-01T12:00:00Z"))
    }
}
