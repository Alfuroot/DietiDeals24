//
//  BuyerView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 17/03/24.
//

import SwiftUI

struct BuyerDashboardView: View {
    @State var search:String = ""
    var articles: [Article] = [
        Article(category: "Technology", info: "Latest gadgets and tech news", id: "1", image: nil),
        Article(category: "Sports", info: "Updates on sports events", id: "2", image: nil),
        Article(category: "Travel", info: "Travel destinations and tips", id: "3", image: nil),
        Article(category: "Food", info: "Cuisine and cooking tips", id: "4", image: nil)
    ]
    var body: some View {
        NavigationStack{
            List{
                ForEach(articles){articolo in
                    NavigationLink(destination: ReverseAuctionDetailView()) {
                        ArticlePreview()
                    }
                    //todo
                }
            }.navigationTitle("Aste")
        }.searchable(text: $search, prompt: "Cerca")
    }
}

struct BuyerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        BuyerDashboardView()
    }
}
