//
//  ArticlePreview.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 17/03/24.
//

import SwiftUI

struct ArticlePreview: View {
    var article: Article

    var body: some View {
        VStack(alignment: .leading) {
            Text(article.category ?? "Unknown Category")
                .font(.headline)
            Text(article.info ?? "No Information Available")
                .font(.subheadline)
        }
    }
}

struct ArticlePreview_Previews: PreviewProvider {
    static var previews: some View {
        ArticlePreview(article: Article(category: "Technology", info: "Latest gadgets and tech news", id: "1", imageData: nil))
    }
}
