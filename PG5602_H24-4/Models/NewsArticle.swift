//
//  NewsArticle.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

import Foundation
import SwiftData

struct Article: Identifiable, Decodable {
    let id: UUID = UUID()
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case title, author, description, url, urlToImage, publishedAt
    }
    
}

struct Source: Decodable {
    let name: String
}

struct ArticlesResponse: Decodable {
    let articles: [Article]
    let status: String
    let totalResults: Int
}

//@Model
//class Article: Decodable {
//    var id: String
//    var author: String?
//    var title: String
//    var articleDescription: String?
//    var url: String
//    var urlToImage: String?
//    var publishedAt: String
//
//    required init(from decoder: any Decoder) throws {
//        let container = try decoder.container(keyedBy: Keys.self)
//        self.id = try container.decode(String.self, forKey: .id)
//        self.author = try container.decodeIfPresent(String.self, forKey: .author)
//        self.title = try container.decode(String.self, forKey: .title)
//        self.articleDescription = try container.decodeIfPresent(String.self, forKey: .description)
//        self.url = try container.decode(String.self, forKey: .url)
//        self.urlToImage = try container.decodeIfPresent(String.self, forKey: .urlToImage)
//        self.publishedAt = try container.decode(String.self, forKey: .publishedAt)
//    }
//
//    init(id: String, title: String, author: String?, articleDescription: String?, url: String, urlToImage: String?, publishedAt: String) {
//        self.id = id
//        self.title = title
//        self.author = author
//        self.articleDescription = articleDescription
//        self.url = url
//        self.urlToImage = urlToImage
//        self.publishedAt = publishedAt
//    }
//
//    enum Keys: String, CodingKey {
//        case id
//        case title
//        case author
//        case description = "description"
//        case url
//        case urlToImage
//        case publishedAt
//    }
//}
//
//    struct Source: Decodable {
//        let name: String
//    }
//    
//    struct ArticlesResponse: Decodable {
//        let articles: [Article]
//        let status: String
//        let totalResults: Int
//    }
