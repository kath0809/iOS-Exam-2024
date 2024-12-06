//
//  NewsAPIService.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import Foundation

class NewsApiService {
    private let topHeadlinesURL = "https://newsapi.org/v2/top-headlines"
    private let everythingURL = "https://newsapi.org/v2/everything"

    // Bruk min nøkkel(defaultApiKey) om det ikke finnes en apiKey
    private func getApiKey() -> String? {
        let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? APIConfig.defaultApiKey
        print("Api key used: \(apiKey)")
        return apiKey.isEmpty ? nil : apiKey
    }
    
    // Det må legges inn en api nøkkel for at noen av api kallene skal virke
//    private func getApiKey() -> String? {
//        let apiKey = UserDefaults.standard.string(forKey: "apiKey")
//        print("Api key used: \(apiKey)")
//        return apiKey?.isEmpty == false ? apiKey : nil
//    }
    
    
    private func performRequest(endpoint: String, queryItems: [URLQueryItem], completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        guard let apiKey = getApiKey() else {
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
            return
        }
        
        var finalQueryItems = queryItems
        finalQueryItems.append(URLQueryItem(name: "apiKey", value: apiKey))
        
        guard var urlComponents = URLComponents(string: endpoint) else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        urlComponents.queryItems = finalQueryItems
        
        guard let url = urlComponents.url else {
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        print("Requesting URL: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            
            print("Raw Response:")
            data.prettyPrintJSON()
            
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
        //
//#if DEBUG
//    completion(.success(MockData.articles))
//    return
//    #endif
//    guard let defaultApiKey = getApiKey() else {
//        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
//        return
//    }
        //
        var queryItems = [URLQueryItem]()
        if let query = query {
            queryItems.append(URLQueryItem(name: "q", value: query))
        }
        performRequest(endpoint: endpoint, queryItems: queryItems, completion: completion)
    }
    
    func fetchTopHeadlines(country: String? = nil, category: String? = nil, pageSize: Int = 20, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
        //
#if DEBUG
    completion(.success(MockData.articles))
    return
    #endif
    guard let defaultApiKey = getApiKey() else {
        completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
        return
    }
        //
        var queryItems = [
            URLQueryItem(name: "pageSize", value: "\(pageSize)")
        ]
        
        if let country = country, country != "All" {
            queryItems.append(URLQueryItem(name: "country", value: country))
        } else {
            queryItems.append(URLQueryItem(name: "country", value: "us"))
        }

        if let category = category, category != "All" {
            queryItems.append(URLQueryItem(name: "category", value: category))
        }
        
        performRequest(endpoint: topHeadlinesURL, queryItems: queryItems, completion: completion)
    }


    
    func searchArticles(query: String, sortBy: String, completion: @escaping (Result<[NewsArticle], Error>) -> Void) {
            //
//    #if DEBUG
//        completion(.success(MockData.articles))
//        return
//        #endif
//        guard let defaultApiKey = getApiKey() else {
//            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
//            return
//        }
            //
        
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
        NewsArticle(author: "BBC",title: "Apple buys Android",  description: "As of 2026 Apple will be the only smartphone manufacturer in the world", url: "https://example.com/1", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
    
        NewsArticle(author: "Fox News",title: "Kamela Harris wins election",  description: "Americas new President is Kamela Harris, the first Black woman to serve as President", url: "https://example.com/2", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
        
        NewsArticle(author: "DailyNews",title: "Biden as santa?",  description: "Biden will be available as santa at Christmas", url: "https://example.com/3", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
        
        NewsArticle(author: "VG",title: "Erna trekker seg som statsminister kandidat",  description: "Sier hun vil fokusere på familie og aksjer", url: "https://example.com/4", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
        
        NewsArticle(author: "NYT",title: "Christmas 2024 - is cancelled",  description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url: "https://example.com/5", urlToImage: "https://thumbs.dreamstime.com/b/cute-kawaii-christmas-ghost-festive-holiday-cartoon-hand-drawing-adorable-pose-297512032.jpg", publishedAt: "2024-12-01T10:00:00Z"),
    ]
}
