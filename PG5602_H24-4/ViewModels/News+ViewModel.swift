//
//  News+ViewModel.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

//import Foundation
//
//@MainActor
//class NewsViewModel: ObservableObject {
//    @Published var articles: [NewsArticle] = []
//    private let apiService = NewsAPIService()
//
//    func loadTopHeadlines(country: String? = nil, category: String? = nil, pageSize: Int = 20) async {
//        do {
//            articles = try await apiService.fetchTopHeadlines(country: country, category: category, pageSize: pageSize)
//        } catch {
//            print("Failed to load top headlines: \(error)")
//        }
//    }
//
//    func searchArticles(query: String, sortBy: String? = nil, pageSize: Int = 20) async {
//        do {
//            articles = try await apiService.searchArticles(query: query, sortBy: sortBy, pageSize: pageSize)
//        } catch {
//            print("Failed to search articles: \(error)")
//        }
//    }
//}
