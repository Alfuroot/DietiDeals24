import SwiftUI

struct MySalesView: View {
    @StateObject private var viewModel = MySalesViewModel()
    @State private var showAddAuctionView: Bool = false
    @State private var showModal: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.sellingItems.isEmpty {
                        Text("No items available")
                            .foregroundColor(.gray)
                    } else {
                        ForEach(viewModel.sellingItems) { auctionItem in
                            SellingItemView(auctionItem: auctionItem)
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
                }
            }
            .sheet(isPresented: $showAddAuctionView) {
                AddAuctionView()
            }
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text("Attenzione"),
                message: Text("Aggiungi l’IBAN al tuo account per accedere a questa sezione"),
                dismissButton: .default(Text("Aggiungi IBAN"), action: {
                    showModal = true
                })
            )
        }
        .sheet(isPresented: $showModal) {
            IBANModalView()
        }
        .onAppear {
            viewModel.checkIBAN()
            viewModel.loadSellingItems()
        }
    }
}

struct MySalesView_Previews: PreviewProvider {
    static var previews: some View {
        MySalesView()
    }
}
