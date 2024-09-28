//
//  ArticleViewModel.swift
//  DietiDeals24
//
//  Created by Giuseppe Carannante on 05/06/24.
//

import Foundation

class DashBoardViewModel: ObservableObject {
    @Published var articles: [Article] = []
    @Published var isLoading = false
    @Published var error: String?
    @Published var availableCategories: [String] = []
    @Published var search: String = ""
    @Published var selectedCategories: [String] = []

    private let apiService = ApiService()
    
    var filteredArticles: [Article] {
        var filtered = articles
        
        if !search.isEmpty {
            filtered = filtered.filter { $0.category?.localizedCaseInsensitiveContains(search) == true }
        }
        
        if !selectedCategories.isEmpty {
            filtered = filtered.filter { article in
                guard let category = article.category else { return false }
                return selectedCategories.contains(category)
            }
        }
        
        return filtered
    }
    
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
                    self.updateAvailableCategories()
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func updateAvailableCategories() {
        let categories = articles.compactMap { $0.category }
        self.availableCategories = Array(Set(categories)).sorted()
    }
}
