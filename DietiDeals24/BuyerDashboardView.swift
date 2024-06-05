//
//  BuyerView.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 17/03/24.
//

import SwiftUI

struct BuyerDashboardView: View {
    @StateObject private var viewModel = ArticleViewModel()
    @State private var search: String = ""

    var filteredArticles: [Article] {
        if search.isEmpty {
            return viewModel.articles
        } else {
            return viewModel.articles.filter { $0.category?.localizedCaseInsensitiveContains(search) == true }
        }
    }

    var body: some View {
        NavigationStack {
            if viewModel.isLoading {
                ProgressView("Loading articles...")
                    .navigationTitle("Aste")
            } else if let error = viewModel.error {
                Text("Error: \(error)")
                    .navigationTitle("Aste")
            } else {
                List {
                    ForEach(filteredArticles) { articolo in
                        NavigationLink(destination: ReverseAuctionDetailView()) {
                            ArticlePreview(article: articolo)
                        }
                    }
                }
                .navigationTitle("Aste")
                .searchable(text: $search, prompt: "Cerca")
                .onAppear {
                    viewModel.fetchArticles()
                }
            }
        }
    }
}

struct BuyerDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        BuyerDashboardView()
    }
}
