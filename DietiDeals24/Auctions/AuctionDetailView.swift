import SwiftUI

struct AuctionDetailView: View {
    @StateObject var viewModel: AuctionDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageUrl = viewModel.auctionItem.imageUrl, let url = URL(string: imageUrl) {
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

                Text(viewModel.auctionItem.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(viewModel.auctionItem.description)
                    .font(.body)

                Text("Current Bid: \(viewModel.formattedCurrentBid)")
                    .font(.headline)

                Text("Bid End Date: \(viewModel.formattedBidEndDate)")
                    .font(.headline)
                    .foregroundColor(.gray)

                TextField("Enter your bid amount", text: $viewModel.bidAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                if viewModel.isReverseAuction() {
                                   Button(action: {
                                       print("Comprato")
                                   }) {
                                       Text("Buyout for \(10000)")
                                           .fontWeight(.bold)
                                           .frame(maxWidth: .infinity)
                                           .padding()
                                           .background(Color.green)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                   }
                               } else {
                                   TextField("Enter your bid amount", text: $viewModel.bidAmount)
                                       .textFieldStyle(RoundedBorderTextFieldStyle())
                                       .keyboardType(.decimalPad)

                                   Button(action: {
                                       let bidAmount = Float(viewModel.bidAmount) ?? 0.0
                                       let bid = Bid(bidderID: "currentUserID", amount: bidAmount)
                                       viewModel.placeBid()
                                   }) {
                                       Text("Place Bid")
                                           .fontWeight(.bold)
                                           .frame(maxWidth: .infinity)
                                           .padding()
                                           .background(Color.blue)
                                           .foregroundColor(.white)
                                           .cornerRadius(10)
                                   }
                               }

                               Spacer()
            }
            .padding()
        }
        .navigationTitle("Auction Details")
    }
}

struct AuctionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleItem = AuctionItem(id: "1", title: "Sample Item", description: "Sample Description", imageUrl: "https://example.com/sample.jpg", currentBid: "$100", bidEndDate: "2024-10-01T12:00:00Z", auctionType: .reverse)
        AuctionDetailView(viewModel: AuctionDetailViewModel(auctionItem: sampleItem))
    }
}
