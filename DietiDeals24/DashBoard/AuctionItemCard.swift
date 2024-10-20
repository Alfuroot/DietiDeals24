import SwiftUI

struct AuctionItemCard: View {
    var auction: Auction
    @StateObject var router: VendorRouter = VendorRouter.shared

    var body: some View {
            HStack {
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
                    Text(auction.auctionItem.title)
                        .font(.headline)
                        .lineLimit(1)
                    
                    Text(auction.auctionItem.description)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)

                    Text("Ends: \(formattedEndDate())")
                        .font(.subheadline)
                        .foregroundColor(.gray)

                    Text("Current Bid: \(auction.currentPrice)")
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

    private func formattedEndDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: auction.endDate)
    }
}
