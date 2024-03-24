//
//  ConfirmAuctionView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 24/03/24.
//

import SwiftUI

struct ConfirmAuctionView: View {
    @State var text: String = ""
    var body: some View {
        VStack{
            Spacer()
            TextField("Importo", text: $text)
            Spacer()
            HStack{
                Button(action: {
                }, label: {
                    Text("Annulla")
                        .frame(width: UIScreen.main.bounds.width * 0.35)
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                        .background( Color.gray)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                })
                Button(action: {
                }, label: {
                    Text("Conferma")
                        .frame(width: UIScreen.main.bounds.width * 0.35)
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                        .background( Color.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                })
            }
        }
    }
}

struct ConfirmAuctionView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmAuctionView()
    }
}
