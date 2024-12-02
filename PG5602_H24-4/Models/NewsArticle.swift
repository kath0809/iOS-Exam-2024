//
//  NewsArticle.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

import Foundation

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
