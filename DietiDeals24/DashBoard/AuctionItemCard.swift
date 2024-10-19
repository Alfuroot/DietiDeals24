import SwiftUI

struct AuctionItemCard: View {
    var auction: Auction
    var body: some View {
        NavigationLink(destination: AuctionDetailView(viewModel: AuctionDetailViewModel(auction: auction))) {
            HStack {
                // Display auction item image
                if let imageUrl = auction.auctionItem.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .background(Color.gray.opacity(0.3))
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                } else {
                    Image(systemName: "camera")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(auction.auctionItem.title)  // Access title from auctionItem
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(auction.auctionItem.description)  // Access description from auctionItem
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)

                    // Display bid end date if available
                    Text("Ends: \(formattedEndDate())")  // Use a formatted date method
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Current Bid: \(auction.currentPrice)")  // Access current price
                        .font(.title3)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 3)
            .padding(.horizontal)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // Helper function to format the end date
    private func formattedEndDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: auction.endDate)  // Access endDate from auction
    }
}

// Preview provider
struct AuctionItemCard_Previews: PreviewProvider {
    static var previews: some View {
        AuctionItemCard(auction: Auction(
            id: "1",
            title: "Sample Item",
            description: "A description of the auction item.",
            initialPrice: 100,
            currentPrice: 150,
            startDate: Date(),
            endDate: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
            auctionType: .classic,
            auctionItem: AuctionItem(title: "Sample Item", description: "A description of the auction item.", category: .tecnologia)
        ))
    }
}
