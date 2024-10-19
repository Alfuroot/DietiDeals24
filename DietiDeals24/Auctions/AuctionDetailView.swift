import SwiftUI

struct AuctionDetailView: View {
    @StateObject var viewModel: AuctionDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Display auction item image
                if let imageUrl = viewModel.auction.auctionItem.imageUrl, let url = URL(string: imageUrl) {
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

                // Display auction title
                Text(viewModel.auction.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Display auction description
                Text(viewModel.auction.description)
                    .font(.body)

                // Display current bid and end date
                Text("Current Bid: \(viewModel.formattedCurrentBid)")
                    .font(.headline)

                Text("Bid End Date: \(viewModel.formattedBidEndDate)")
                    .font(.headline)
                    .foregroundColor(.gray)

                // Input field for bid amount
                TextField("Enter your bid amount", text: $viewModel.bidAmount)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                // Conditional button display based on auction type
                if viewModel.isReverseAuction() {
                    Button(action: {
                        viewModel.buyout() // Function to handle buyout
                    }) {
                        Text("Buyout for \(viewModel.auction.buyoutPrice ?? 0.0, specifier: "%.2f")")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Button(action: {
                        let bidAmount = Float(viewModel.bidAmount) ?? 0.0
                        let bid = Bid(bidderID: "currentUserID", amount: bidAmount) // Replace with actual user ID
                        viewModel.placeBid() // Pass the bid object to the function
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
