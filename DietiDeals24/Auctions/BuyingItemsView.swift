import SwiftUI

struct BuyingItemView: View {
    @StateObject var viewModel: BuyingItemViewModel

    var body: some View {
        HStack {
            // Image handling
            if let url = viewModel.imageUrl {
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
                Text(viewModel.itemTitle) // Title of the auction item
                    .font(.headline)
                    .lineLimit(1)

                Text(viewModel.userBidText) // User's bid information
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(viewModel.bidEndDateText) // Bid end date
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(viewModel.auctionStatusText) // Auction status
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.auctionStatusColor) // Dynamic color based on status

                Text(viewModel.highestBidText) // Highest bid information
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
        .onTapGesture {
            // Optional: Add navigation or interaction here
            print("Tapped on auction item: \(viewModel.itemTitle)")
        }
    }
}
