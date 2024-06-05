//
//  ArticleViewModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 05/06/24.
//

import Foundation

class ArticleViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: String?

    private let apiService = ApiService()
    
    init() {
        fetchArticles()
    }
    
    func fetchArticles() {
        Task {
            do {
                isLoading = true
                let fetchedArticles = try await apiService.getArticles()
                DispatchQueue.main.async {
                    self.articles = fetchedArticles
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
