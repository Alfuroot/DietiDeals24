import SwiftUI

struct DashBoard: View {
    @StateObject private var viewModel = DashBoardViewModel()
    
    @State private var isFiltersPresented: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                if viewModel.filteredItems.isEmpty {
                    Text("No items available")
                        .foregroundColor(.gray)
                } else {
                    VStack(spacing: 20) {
                        ForEach(viewModel.filteredItems, id: \.self) { item in
                            AuctionItemCard(auction: item)
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
        }
        .onAppear {
            viewModel.fetchAuctionItems()
        }
    }
}
