//
//  APIService.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

//import Foundation
//
//class NewsAPIService {
//    private let session = URLSession.shared
//
//    // Fetch top headlines
//    func fetchTopHeadlines(country: String?, category: String?, pageSize: Int = 20) async throws -> [NewsArticle] {
//        // Endepunkt top-hedlines
//        let endpoint = "\(APIConfig.baseUrl)/top-headlines"
//        
//        var components = URLComponents(string: endpoint)
//        components?.queryItems = [
//            URLQueryItem(name: "apiKey", value: APIConfig.apiKey),
//            URLQueryItem(name: "pageSize", value: "\(pageSize)")
//        ]
//        if let country = country {
//            components?.queryItems?.append(URLQueryItem(name: "country", value: country))
//        }
//        if let category = category {
//            components?.queryItems?.append(URLQueryItem(name: "category", value: category))
//        }
//
//        guard let url = components?.url else {
//            throw URLError(.badURL)
//        }
//
//        let (data, _) = try await session.data(from: url)
//        if let jsonString = String(data: data, encoding: .utf8) {
//            print("JSON response: \(jsonString)")
//        }
//        let response = try JSONDecoder().decode(NewsResponse.self, from: data)
//        //print("Parsed Article: \(response.articles)")
//        return response.articles
//    }
//
//    // Search articles
//    func searchArticles(query: String, sortBy: String? = nil, pageSize: Int = 20) async throws -> [NewsArticle] {
//        let endpoint = "\(APIConfig.baseUrl)/everything"
//        var components = URLComponents(string: endpoint)
//        components?.queryItems = [
//            URLQueryItem(name: "apiKey", value: APIConfig.apiKey),
//            URLQueryItem(name: "q", value: query),
//            URLQueryItem(name: "pageSize", value: "\(pageSize)")
//        ]
//        if let sortBy = sortBy {
//            components?.queryItems?.append(URLQueryItem(name: "sortBy", value: sortBy))
//        }
//
//        guard let url = components?.url else {
//            throw URLError(.badURL)
//        }
//
//        let (data, _) = try await session.data(from: url)
//        let response = try JSONDecoder().decode(NewsResponse.self, from: data)
//        return response.articles
//    }
//}


