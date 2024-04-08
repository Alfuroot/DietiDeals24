//
//  FixedTimeView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 23/03/24.
//

import SwiftUI

struct FixedTimeAuctionView: View {
    var body: some View {
        NavigationStack{
            VStack{
                Image(systemName: "square.fill").resizable().cornerRadius(10).frame(width: UIScreen.main.bounds.width * 0.4,                        height:UIScreen.main.bounds.height * 0.2)
                Text("Nome prodotto")
                Spacer()
                Text("descrizione")
                Text("tempo")
                List{
                    ScrollView{
                        Text("utente1  offerta2")
                        Text("utente2  offerta2")
                        Text("...")
                    }
                }
                Spacer()
                NavigationLink( destination:   ConfirmAuctionView(), label:{Text("Fai un'offerta")
                        .frame(width: UIScreen.main.bounds.width * 0.45)
                        .frame(height: UIScreen.main.bounds.height * 0.06)
                        .background( Color.blue)
                        .cornerRadius(10)
                    .foregroundColor(.white)})
            }
        }
    }
}

struct FixedTimeAuctionView_Previews: PreviewProvider {
    static var previews: some View {
        FixedTimeAuctionView()
    }
}
