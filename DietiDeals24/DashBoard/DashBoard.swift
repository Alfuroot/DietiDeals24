import SwiftUI

struct DashBoard: View {
    @StateObject private var dataLoader = DataLoader()
    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                let filteredItems = dataLoader.allItems.filter { item in
                    searchText.isEmpty || (item.title.localizedCaseInsensitiveContains(searchText) || item.description.localizedCaseInsensitiveContains(searchText))
                }

                if filteredItems.isEmpty {
                    Text("No items available")
                        .foregroundColor(.gray)
                } else {
                    VStack(spacing: 20) {
                        ForEach(filteredItems) { item in
                            AuctionItemCard(auctionItem: item)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("HOME")
            .searchable(text: $searchText, prompt: "Search items")
        }
    }
}
