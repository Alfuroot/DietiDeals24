import SwiftUI

struct BuyingItemView: View {
    @StateObject var viewModel: BuyingItemViewModel

    var body: some View {
        if viewModel.isOutbid {
            NavigationLink(destination: AuctionDetailView(viewModel: AuctionDetailViewModel(auctionItem: viewModel.auctionItem))) {
                content
            }
        } else {
            content
        }
    }

    private var content: some View {
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

                if !viewModel.bidEndDateText.isEmpty {
                    Text(viewModel.bidEndDateText)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }

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

struct BuyingItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BuyingItemView(viewModel: BuyingItemViewModel(auctionItem: AuctionItem(id: "1", title: "Sample Item", description: "A description of the auction item.", imageUrl: "https://example.com/sample.jpg", currentBid: "$100", bidEndDate: "2024-10-01T12:00:00Z", auctionType: .reverse, userBid: "$90", auctionStatus: "Outbid")))
        }
    }
}
