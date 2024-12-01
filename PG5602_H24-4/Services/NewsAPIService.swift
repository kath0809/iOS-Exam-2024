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
    //private let defaultApiKey = "3cefd6c6ab294e36bbd0ba6124fee341"
    private let baseURL = "https://api.example.com/news"

    func fetchNews(completion: @escaping (Result<[String], Error>) -> Void) {
        let apiKey = UserDefaults.standard.string(forKey: "apiKey") ?? APIConfig.apiKey
        
        guard !apiKey.isEmpty else {
            print("API key is missing")
            completion(.failure(NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "API key is missing"])))
            return
        }

        guard let url = URL(string: "\(baseURL)?apiKey=\(apiKey)") else {
            print("Invalid URL")
            completion(.failure(NSError(domain: "", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "", code: 500, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }

            // Placeholder for decoding response - here we just return an empty list of news titles
            completion(.success(["News Item 1", "News Item 2", "News Item 3"]))
        }.resume()
    }
}

