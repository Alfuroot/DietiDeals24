import SwiftUI

struct MyAuctionsView: View {
    @StateObject private var viewModel = MyAuctionsViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                    } else if let error = viewModel.error {
                        Text("Error: \(error)")
                            .foregroundColor(.red)
                    } else if viewModel.sortedAuctions.isEmpty {
                        Text("You are not participating in any auctions.")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    } else {
                        ForEach(viewModel.sortedAuctions, id: \.self) { auction in
                            BuyingItemView(viewModel: BuyingItemViewModel(auction: auction))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("My Purchases")
            .task {
                viewModel.fetchAuctions()
            }
        }
    }
}

#Preview {
    MyAuctionsView()
}
