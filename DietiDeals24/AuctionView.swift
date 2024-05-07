//
//  AuctionView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import SwiftUI

struct AuctionView: View {
    @State private var auctionItem = AuctionItem(
        id: UUID(),
        title: "Vintage Watch",
        description: "A classic vintage watch in excellent condition.",
        imageUrl: "https://example.com/watch.jpg",
        currentBid: 150.0,
        bidEndDate: Date().addingTimeInterval(3600) // 1 hour from now
    )
    @State private var bidAmount: String = ""
    @State private var timerString: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Product Image
            AsyncImage(url: URL(string: auctionItem.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
            } placeholder: {
                ProgressView()
            }

            // Product Title
            Text(auctionItem.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            // Product Description
            Text(auctionItem.description)
                .font(.body)
                .foregroundColor(.secondary)

            // Current Bid
            HStack {
                Text("Current Bid: ")
                Text("$\(auctionItem.currentBid, specifier: "%.2f")")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            // Bid Amount Input
            HStack {
                TextField("Enter your bid", text: $bidAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                Button(action: placeBid) {
                    Text("Bid")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }

            // Countdown Timer
            Text("Time Left: \(timerString)")
                .font(.headline)
                .foregroundColor(.red)
                .onAppear {
                    startTimer()
                }

            Spacer()
        }
        .padding()
    }

    func placeBid() {
        if let bid = Double(bidAmount), bid > auctionItem.currentBid {
            auctionItem.currentBid = bid
            bidAmount = ""
        }
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let timeLeft = auctionItem.bidEndDate.timeIntervalSinceNow
            if timeLeft > 0 {
                timerString = formatTimeInterval(timeLeft)
            } else {
                timerString = "Auction Ended"
            }
        }
    }

    func formatTimeInterval(_ interval: TimeInterval) -> String {
        let seconds = Int(interval) % 60
        let minutes = (Int(interval) / 60) % 60
        let hours = Int(interval) / 3600
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct AuctionView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionView()
    }
}
