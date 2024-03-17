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
    var image: String?
    
    init(category: String?, info: String?, id: String, image: String?) {
            self.category = category
            self.info = info
            self.id = id
            self.image = image
        }
}
