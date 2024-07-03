//
//  VendorDashbordView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import SwiftUI



struct VendorDashboardView: View {
    var activeAuctions: [AuctionItem] = [
//        AuctionItem(id: UUID(), title: "Vintage Camera", description: "A classic camera in excellent condition.", imageUrl: "camera.jpg", currentBid: 120.00, bidEndDate: Date()),
//        AuctionItem(id: UUID(), title: "Antique Vase", description: "A beautiful vase from the 19th century.", imageUrl: "vase.jpg", currentBid: 450.50, bidEndDate: Date()),
//        AuctionItem(id: UUID(), title: "Rare Book Collection", description: "A collection of rare books on history.", imageUrl: "books.jpg", currentBid: 300.00, bidEndDate: Date())
    ]

    var body: some View {
        NavigationView {
            List(activeAuctions, id: \.id) { auction in
                VStack(alignment: .leading) {
                    AsyncImage(url: URL(string: auction.imageUrl ?? "")) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)

                    Text(auction.title ?? "")
                        .font(.headline)
                    Text("Current Bid: $\(auction.currentBid ?? "")")
                        .font(.subheadline)
                    Text("Ends on: \(auction.bidEndDate ?? "")")
                        .font(.subheadline)
                }
            }
            .navigationTitle("Active Auctions")
        }
    }
}

struct VendorDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        VendorDashboardView()
    }
}
