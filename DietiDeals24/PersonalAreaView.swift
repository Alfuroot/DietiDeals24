//
//  PersonalAreaView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 18/03/24.
//

import SwiftUI

struct PersonalAreaView: View {
    var body: some View {
        NavigationStack{
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: UIScreen.main.bounds.width * 0.4,                        height:UIScreen.main.bounds.height * 0.2)
                .clipShape(Circle())
            List{
                Text("Nome utente")
                Text("Password")
                Text("Email")
                Text("Indirizzo")
                Text("Notifiche")
                Text("Elimina account")
                Text("Logout")
                //NavigationLink(destination: self, label: {Text("")})
            }
        }
    }
}

struct PersonalAreaView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalAreaView()
    }
}
