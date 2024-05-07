//
//  AddAuctionView.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 07/05/24.
//

import SwiftUI

struct AddAuctionView: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var imageUrl: String = ""
    @State private var currentBid: String = ""
    @State private var bidEndDate = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Auction Details")) {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description)
                    TextField("Image URL", text: $imageUrl)
                    TextField("Current Bid", text: $currentBid)
                        .keyboardType(.decimalPad)
                    DatePicker("Bid End Date", selection: $bidEndDate, displayedComponents: .date)
                }
                
                Button("Add Auction") {
                    // To do
                }
            }
            .navigationTitle("Add New Auction")
        }
    }
}

struct AddAuctionView_Previews: PreviewProvider {
    static var previews: some View {
        AddAuctionView()
    }
}
