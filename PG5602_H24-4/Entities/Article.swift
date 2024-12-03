//
//  StoredArticle.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 02/12/2024.
//

import Foundation
import SwiftData

//@Model
//class Article: Identifiable {
//    @Attribute(.unique) var id: UUID
//    var author: String?
//    var title: String
//    var url: String
//    var urlToImage: String?
//    var content: String?
//    var publishedAt: String?
//    var articleDescription: String?
//    var savedDate: Date
//    var editedDate: Date?
//    var category: Category?
//    var note: String?
//    
//    init(article: NewsArticle, category: Category? = nil, note: String? = nil ) {
//        self.id = UUID()
//        self.author = article.author
//        self.title = article.title
//        self.url = article.url
//        self.urlToImage = article.urlToImage
//        self.content = article.description
//        self.publishedAt = article.publishedAt
//        self.articleDescription = article.description
//        self.savedDate = Date()
//        self.editedDate = nil
//        self.category = category
//        self.note = note
//    }
//}

@Model
class Article: Identifiable {
    @Attribute(.unique) var id: UUID
    var author: String?
    var title: String
    var url: String
    var urlToImage: String?
    var articleDescription: String?
    var publishedAt: String?
    var savedDate: Date
    @Relationship(deleteRule: .nullify) var category: Category?
    var note: String?

    init(article: NewsArticle, category: Category? = nil, note: String? = nil ) {
        self.id = UUID()
        self.author = article.author
        self.title = article.title
        self.url = article.url
        self.urlToImage = article.urlToImage
        self.articleDescription = article.description
        self.publishedAt = article.publishedAt
        self.savedDate = Date()
        self.category = category
        self.note = note
    }
}