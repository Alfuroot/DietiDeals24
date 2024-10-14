import SwiftUI

struct AddAuctionView: View {
    @StateObject private var viewModel = AddAuctionViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    HStack {
                        Text("Nome:")
                            .bold()
                        Spacer()
                        TextField("Inserisci il nome", text: $viewModel.auctionTitle)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                    }
                }
                
                Section {
                    HStack {
                        Text("Categoria:")
                            .bold()
                        Spacer()
                        Picker("", selection: $viewModel.auctionItemType) {
                            ForEach(AuctionItemType.allCases, id: \.self) { itemType in
                                Text(itemType.rawValue.capitalized).tag(itemType)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 200)
                    }
                }
                
                Section {
                    HStack {
                        Text("Informazioni:")
                            .bold()
                        Spacer()
                        TextField("Aggiungi ulteriori dettagli", text: $viewModel.auctionDescription)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 200)
                    }
                }
                
                Section(header: Text("Tipo di Asta")) {
                    Picker("Tipo di Asta", selection: $viewModel.auctionType) {
                        ForEach(AuctionType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                if viewModel.auctionType == .reverse {
                    Section(header: Text("Dettagli Asta Inversa")) {
                        HStack {
                            Text("Prezzo Iniziale:")
                                .bold()
                            Spacer()
                            TextField("€ 0,0", text: $viewModel.buyoutPrice)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)
                        }
                        HStack {
                            Text("Decremento:")
                                .bold()
                            Spacer()
                            TextField("€ 0,0", text: $viewModel.decrementAmount)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)
                        }
                        HStack {
                            Text("Timer (minuti):")
                                .bold()
                            Spacer()
                            TextField("minuti", text: $viewModel.decrementInterval)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)
                        }
                        HStack {
                            Text("Prezzo minimo:")
                                .bold()
                            Spacer()
                            TextField("€ 0,0", text: $viewModel.floorPrice)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)
                        }
                    }
                } else {
                    Section {
                        HStack {
                            Text("Prezzo min:")
                                .bold()
                            Spacer()
                            TextField("€ 0,0", text: $viewModel.auctionMinPrice)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 200)
                        }
                    }
                    
                    Section {
                        HStack {
                            Text("Scadenza:")
                                .bold()
                            Spacer()
                            DatePicker("", selection: $viewModel.auctionEndDate, in: Date.now..., displayedComponents: .date)
                                .datePickerStyle(CompactDatePickerStyle())
                                .frame(width: 200)
                        }
                    }
                }
                
                Button(action: {
                    viewModel.addAuction()
                }) {
                    Text("Aggiungi l'asta")
                        .bold()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
            .navigationTitle("Aggiungi Asta")
        }
    }
}

struct AddAuctionView_Previews: PreviewProvider {
    static var previews: some View {
        AddAuctionView()
    }
}
