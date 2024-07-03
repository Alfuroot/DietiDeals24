//
//  AuctionView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import SwiftUI

struct AuctionView: View {
    @State private var auctionItem = AuctionItem(
            id: UUID().uuidString,
            title: "Vintage Watch",
            description: "A classic vintage watch in excellent condition.",
            imageUrl: "https://example.com/watch.jpg",
            currentBid: String(format: "%.2f", 150.0),
            bidEndDate: ISO8601DateFormatter().string(from: Date().addingTimeInterval(3600)) // 1 hour from now
        )
    @State private var bidAmount: String = ""
    @State private var timerString: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Product Image
            AsyncImage(url: URL(string: auctionItem.imageUrl ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 300)
            } placeholder: {
                ProgressView()
            }

            // Product Title
            Text(auctionItem.title ?? "")
                .font(.largeTitle)
                .fontWeight(.bold)

            // Product Description
            Text(auctionItem.description ?? "")
                .font(.body)
                .foregroundColor(.secondary)

            // Current Bid
            HStack {
                Text("Current Bid: ")
                Text("$\(auctionItem.currentBid ?? "")")
                    .font(.headline)
                    .foregroundColor(.green)
            }

            // Bid Amount Input
            HStack {
                TextField("Enter your bid", text: $bidAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                Button(action: {
//                    placeBid
                }) {
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
//                    startTimer()
                }

            Spacer()
        }
        .padding()
    }
}

struct AuctionView_Previews: PreviewProvider {
    static var previews: some View {
        AuctionView()
    }
}
