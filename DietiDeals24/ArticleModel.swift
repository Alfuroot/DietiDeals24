//
//  ArticleModel.swift
//  DietiDeals24
//
//  Created by Alessandro De Gregorio on 16/03/24.
//

import Foundation

class Article: Codable, Identifiable {
    var category: String?
    var info: String?
    var id: String
    var imageData: Data?
    
    init(category: String?, info: String?, id: String, imageData: Data?) {
        self.category = category
        self.info = info
        self.id = id
        self.imageData = imageData
    }
    
    init(remoteArticle: RemoteArticle) {
        self.category = remoteArticle.category
        self.info = remoteArticle.info
        self.id = remoteArticle.id
        if let imageUrl = remoteArticle.imageUrl {
            self.imageData = try? Data(contentsOf: URL(string: imageUrl)!)
        } else {
            self.imageData = nil
        }
    }
}
