import SwiftUI

struct DashBoard: View {
    @StateObject private var viewModel = DashBoardViewModel()
    @State private var isFiltersPresented: Bool = false
    @ObservedObject private var router = VendorRouter.shared

    var body: some View {
        NavigationStack(path: $router.navPath) {
            ScrollView {
                if viewModel.filteredItems.isEmpty {
                    Text("No items available")
                        .foregroundColor(.gray)
                } else {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredItems, id: \.self) { item in
                            AuctionItemCard(auction: item)
                                .onTapGesture {
                                    viewModel.selectedAuction = item
                                    router.navigate(to: .catalogDetail)
                                }
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("HOME")
            .searchable(text: $viewModel.search, prompt: "Search items")
            .toolbar {
                Button(action: {
                    isFiltersPresented.toggle()
                }) {
                    Text("Filters")
                }
            }
            .sheet(isPresented: $isFiltersPresented) {
                FilterView(selectedCategories: $viewModel.selectedCategories)
            }
            .navigationDestination(for: VendorRouter.Destination.self) { destination in
                switch destination {
                case .catalogDetail:
                    if let selectedAuction = viewModel.selectedAuction {
                        AuctionDetailView(viewModel: AuctionDetailViewModel(auction: selectedAuction))
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchAuctionItems()
        }
    }
}
