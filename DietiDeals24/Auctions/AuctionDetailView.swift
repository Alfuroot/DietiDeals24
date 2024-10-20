import SwiftUI

struct AuctionDetailView: View {
    @StateObject var viewModel: AuctionDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                        viewModel.buyout()
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
                        Task {
                            viewModel.placeBid()
                        }
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
        .alert(item: $viewModel.alertMessage) { alertMessage in
            Alert(title: Text("Error"),
                  message: Text(alertMessage.message),
                  dismissButton: .default(Text("OK")))
        }
    }
}
