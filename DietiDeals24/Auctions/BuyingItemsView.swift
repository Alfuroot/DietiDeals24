import SwiftUI

struct BuyingItemView: View {
    @StateObject var viewModel: BuyingItemViewModel

    var body: some View {
        HStack {
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
                Text(viewModel.itemTitle)
                    .font(.headline)
                    .lineLimit(1)

                Text(viewModel.userBidText)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(viewModel.bidEndDateText)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(viewModel.auctionStatusText)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.auctionStatusColor)

                Text(viewModel.highestBidText)
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
}
