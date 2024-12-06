//
//  NewsAPIService.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//


//import Foundation
//
//class NewsApiService {
//    private let topHeadlinesURL = "https://newsapi.org/v2/top-headlines"
//    private let everythingURL = "https://newsapi.org/v2/everything"
//    
//    func fetchNews(endpoint: String, query: String? = nil, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
////#if DEBUG
//            // Bruk mock-data for å unngå ekte API-kall i preview
//        completion(.success(MockData.articles))
////#else
//        let apiKey = APIConfig.apiKey
//            //let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? APIConfig.apiKey
//        
//        
//        guard !apiKey.isEmpty else {
//            print("API key is missing")
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
//            return
//        }
//        
//            // Bygg URLen basert på endpoint og query
//        guard var urlComponents = URLComponents(string: endpoint) else {
//            print("Invalid URL")
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        var queryItems = [
//            URLQueryItem(name: "apiKey", value: apiKey),
//            URLQueryItem(name: "pageSize", value: "20")
//        ]
//        
//        if let query = query {
//            queryItems.append(URLQueryItem(name: "q", value: query))
//        }
//        
//        urlComponents.queryItems = queryItems
//        
//        guard let url = urlComponents.url else {
//            print("Invalid URL")
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//            // Utfør forespørselen
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                let newsResponse = try decoder.decode(ArticlesResponse.self, from: data)
//                completion(.success(newsResponse.articles))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
////#endif
//    }
//    
//        // Hent toppnyheter
//    func fetchTopHeadlines(country: String? = nil, category: String? = nil, pageSize: Int = 20, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
////#if DEBUG
////        completion(.success(MockData.articles))
////        return
////        #endif
//        
//        let apiKey = APIConfig.apiKey
//        guard !apiKey.isEmpty else {
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
//            return
//        }
//        
//        var queryItems = [
//            URLQueryItem(name: "apiKey", value: apiKey),
//            URLQueryItem(name: "pageSize", value: String(pageSize))
//        ]
//        
//        if let country = country, country != "All" {
//            queryItems.append(URLQueryItem(name: "country", value: country))
//        }
//        
//        if let category = category, category != "All" {
//            queryItems.append(URLQueryItem(name: "category", value: category))
//        }
//        
//        guard var urlComponents = URLComponents(string: topHeadlinesURL) else {
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        urlComponents.queryItems = queryItems
//        
//        guard let url = urlComponents.url else {
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                let newsResponse = try decoder.decode(ArticlesResponse.self, from: data)
//                completion(.success(newsResponse.articles))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//    func searchArticles(query: String, sortBy: String, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
////#if DEBUG
////        completion(.success(MockData.articles))
////        return
////        #endif
//        
//        guard !query.isEmpty else {
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Query is empty"])))
//            return
//        }
//        
//        var queryItems = [
//            URLQueryItem(name: "apiKey", value: APIConfig.apiKey),
//            URLQueryItem(name: "q", value: query),
//            URLQueryItem(name: "pageSize", value: "20")
//        ]
//        
//        queryItems.append(URLQueryItem(name: "sortBy", value: sortBy))
//        
//        guard var urlComponents = URLComponents(string: everythingURL) else {
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        urlComponents.queryItems = queryItems
//        
//        guard let url = urlComponents.url else {
//            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                completion(.failure(error))
//                return
//            }
//            
//            guard let data = data else {
//                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                let newsResponse = try decoder.decode(ArticlesResponse.self, from: data)
//                completion(.success(newsResponse.articles))
//            } catch {
//                completion(.failure(error))
//            }
//        }.resume()
//    }
//
//}

import Foundation

class NewsApiService {
    private let topHeadlinesURL = "https://newsapi.org/v2/top-headlines"
    private let everythingURL = "https://newsapi.org/v2/everything"

    // Bruk min nøkkel(defaultApiKey) om det ikke finnes en apiKey
    private func getApiKey() -> String? {
        let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? APIConfig.defaultApiKey
        return apiKey.isEmpty ? nil : apiKey
    }
    
    // Det må legges inn en api nøkkel for at noen av api kallene skal virke
//    private func getApiKey() -> String? {
//        let apiKey = UserDefaults.standard.string(forKey: "apiKey")
//        return apiKey?.isEmpty == false ? apiKey : nil
//    }

    private func performRequest(endpoint: String, queryItems: [URLQueryItem], completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        guard let apiKey = getApiKey() else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
            return
        }

        var finalQueryItems = queryItems
        finalQueryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
        finalQueryItems.append(URLQueryItem(name: "pageSize", value: "20"))

        guard var urlComponents = URLComponents(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        urlComponents.queryItems = finalQueryItems

        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let articlesResponse = try decoder.decode(ArticlesResponse.self, from: data)
                completion(.success(articlesResponse.articles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    func fetchNews(endpoint: String, query: String? = nil, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        var queryItems = [URLQueryItem]()
        if let query = query {
            queryItems.append(URLQueryItem(name: "q", value: query))
        }
        performRequest(endpoint: endpoint, queryItems: queryItems, completion: completion)
    }

    func fetchTopHeadlines(country: String? = nil, category: String? = nil, pageSize: Int = 20, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        var queryItems = [
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        if let country = country, country != "All" {
            queryItems.append(URLQueryItem(name: "country", value: country))
        }
        if let category = category, category != "All" {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        performRequest(endpoint: topHeadlinesURL, queryItems: queryItems, completion: completion)
    }

    func searchArticles(query: String, sortBy: String, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        guard !query.isEmpty else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Query is empty"])))
            return
        }
        let queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "sortBy", value: sortBy)
        ]
        performRequest(endpoint: everythingURL, queryItems: queryItems, completion: completion)
    }
}




struct MockData {
    static let articles = [
        NewsArticle(author: "Mock Author",title: "Mock Title 1",  description: "This is a mock description 1", url: "https://example.com/1", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
    
        NewsArticle(author: "Mock Author 2",title: "Mock Title 2",  description: "This is a mock description 2", url: "https://example.com/2", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
        
        NewsArticle(author: "Mock Author 3",title: "Mock Title 3",  description: "This is a mock description 2", url: "https://example.com/3", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
        
        NewsArticle(author: "Mock Author 3",title: "Mock Title 4",  description: "This is a mock description 2", url: "https://example.com/3", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
        
        NewsArticle(author: "Mock Author 3",title: "Mock Title 5",  description: "This is a mock description 2", url: "https://example.com/3", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
    ]
}
