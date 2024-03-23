//
//  ReverseAuctionDetailView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 23/03/24.
//

import SwiftUI

struct ReverseAuctionDetailView: View {
    var body: some View {
        VStack{
            Image(systemName: "square.fill").resizable().cornerRadius(10).frame(width: UIScreen.main.bounds.width * 0.4,                        height:UIScreen.main.bounds.height * 0.2)
            Text("Nome prodotto")
            Spacer()
            Text("descrizione")
            Spacer()
            Button(action: {
            }, label: {
                Text("Buy")
                    .frame(width: UIScreen.main.bounds.width * 0.45)
                    .frame(height: UIScreen.main.bounds.height * 0.06)
                    .background( Color.blue)
                    .cornerRadius(10)
                    .foregroundColor(.white)
            })
        }
        
    }
}

struct ReverseAuctionDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReverseAuctionDetailView()
    }
}
