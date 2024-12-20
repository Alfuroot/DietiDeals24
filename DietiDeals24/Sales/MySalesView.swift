import SwiftUI

struct MySalesView: View {
    @StateObject private var viewModel = MySalesViewModel()
    @State private var showAddAuctionView: Bool = false
    @State private var showModal: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.sellingAuctions.isEmpty {
                        Text("No items available")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.sellingAuctions, id: \.self) { auction in
                            SellingItemView(auction: auction)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("My Sales")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showAddAuctionView.toggle()
                    }) {
                        Image(systemName: "plus")
                    }
                    .disabled(User.shared.iban == nil)
                }
            }
            .sheet(isPresented: $showAddAuctionView) {
                AddAuctionView()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Attention"),
                message: Text("Please add your IBAN to access this section."),
                dismissButton: .default(Text("Add IBAN"), action: {
                    showModal = true
                })
            )
        }
        .sheet(isPresented: $showModal) {
            IBANModalView()
        }
        .onAppear {
            if viewModel.checkIBAN() {
                viewModel.loadSellingAuctions()
            } else {
                viewModel.showAlert = true
            }
        }
        .refreshable(action: {
            viewModel.loadSellingAuctions()
        })
    }
}

struct MySalesView_Previews: PreviewProvider {
    static var previews: some View {
        MySalesView()
    }
}
