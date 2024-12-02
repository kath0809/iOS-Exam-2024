//
//  StoredArticle.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 02/12/2024.
//

import Foundation
import SwiftData

@Model
class StoredArticle: Identifiable {
    @Attribute(.unique) var id: UUID
    var title: String
    var url: String
    var urlToImage: String?
    var content: String?
    var publishedAt: String?
    var articleDescription: String?
    var savedDate: Date
    var editedDate: Date?
    
    init(article: Article) {
        self.id = UUID()
        self.title = article.title
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.content = article.description
        self.publishedAt = article.publishedAt
        self.articleDescription = article.description
        self.savedDate = Date()
        self.editedDate = nil
    }
}
