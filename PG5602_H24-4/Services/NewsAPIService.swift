    //
    //  NewsAPIService.swift
    //  PG5602_H24-4
    //
    //  Created by Karima Thingvold on 01/12/2024.
    //

//import Foundation
//
//class NewsAPIService {
//    @Published var articles: [Article] = []
//    
//    let baseURL = "https://newsapi.org/v2/top-headlines"
//    let apiKey = "3cefd6c6ab294e36bbd0ba6124fee341"
//    
//    func fetchArticles() {
//        guard let url = URL(string: "\(baseURL)?apiKey=\(apiKey)") else {
//            print("Error: invalid URL")
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//                return
//            }
//            
//            guard let data = data else {
//                print("Error: no data returned")
//                return
//            }
//            do {
//                let decoder = try JSONDecoder().decode(NewsResponse.self, from: data)
//                DispatchQueue.main.async {
//                    self.articles = decoder.articles
//                }
//            } catch {
//                print("Wrong with decoding: \(error)")
//            }
//        }.resume()
//        
//        
//    }
//}


import Foundation

class NewsApiService {
    private let topHeadlinesURL = "https://newsapi.org/v2/top-headlines"
    private let everythingURL = "https://newsapi.org/v2/everything"

    // Hent nyheter basert på en spesifikk type søk (top-headlines eller everything)
    func fetchNews(endpoint: String, query: String? = nil, completion: @escaping (Result<[Article], Error>) -> Void) {
#if DEBUG
        // Bruk mock-data for å unngå ekte API-kall i preview
        completion(.success(MockData.articles))
        #else
        let apiKey = APIConfig.apiKey
        //let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? APIConfig.apiKey
        
        let apiKey = APIConfig.apiKey

        guard !apiKey.isEmpty else {
            print("API key is missing")
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
            return
        }

        // Bygg URLen basert på endpoint og query
        guard var urlComponents = URLComponents(string: endpoint) else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        var queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "pageSize", value: "20")
        ]

        if let query = query {
            queryItems.append(URLQueryItem(name: "q", value: query))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        // Utfør forespørselen
        URLSession.shared.dataTask(with: url) { data, response, error in
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
                let newsResponse = try decoder.decode(ArticlesResponse.self, from: data)
                completion(.success(newsResponse.articles))
            } catch {
                completion(.failure(error))
            }
        }.resume()
#endif
    }
    

    // Hent toppnyheter
    func fetchTopHeadlines(completion: @escaping (Result<[Article], Error>) -> Void) {
        fetchNews(endpoint: topHeadlinesURL, completion: completion)
    }

    // Hent nyheter med et spesifikt søkeord
    func searchArticles(query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        fetchNews(endpoint: everythingURL, query: query, completion: completion)
    }
}

struct MockData {
    static let articles = [
        Article(author: "Mock Author",title: "Mock Title 1",  description: "This is a mock description 1", url: "https://example.com/1", urlToImage: "https://seeklogo.com/images/N/new-york-times-logo-EE0F194CA3-seeklogo.com.png", publishedAt: "2024-12-01T10:00:00Z"),
        
        Article(author: "Mock Author 2",title: "Mock Title 2",  description: "This is a mock description 2", url: "https://example.com/2", urlToImage: "https://seeklogo.com/images/B/bbc-news-logo-8648ABD044-seeklogo.com.png", publishedAt: "2024-12-01T10:00:00Z"),
        Article(author: "Mock Author 3",title: "Mock Title 3",  description: "This is a mock description 2", url: "https://example.com/3", urlToImage: "https://download.logo.wine/logo/CNN/CNN-Logo.wine.png", publishedAt: "2024-12-01T10:00:00Z"),
    ]
}
