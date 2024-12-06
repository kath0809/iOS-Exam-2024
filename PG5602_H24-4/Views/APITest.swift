//
//  APITest.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 06/12/2024.
//

import SwiftUI

//struct APITest: View {
//    @State private var articles: [NewsArticle] = []
//    @State private var errorMessage: String?
//    @State private var isLoading: Bool = false
//    @AppStorage("apiKey") private var apiKey: String = ""
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isLoading {
//                    ProgressView("Fetching articles...")
//                        .padding()
//                } else if let errorMessage = errorMessage {
//                    Text(errorMessage)
//                        .foregroundStyle(.red)
//                        .font(.largeTitle)
//                        .fontWeight(.semibold)
//                        .padding()
//
//                } else {
//
//                    List(articles, id: \.url) { article in
//                        VStack(alignment: .leading) {
//                            Text(article.title)
//                                .font(.headline)
//                            if let description = article.description {
//                                Text(description)
//                                    .font(.subheadline)
//                                    .foregroundStyle(.secondary)
//                            }
//                        }
//                    }
//                }
//
//                Spacer()
//
//                Section() {
//                    HStack {
//                        TextField("Enter API Key", text: $apiKey)
//                            .textInputAutocapitalization(.none)
//                            .autocorrectionDisabled(true)
//                            .padding()
//                            .background(.gray.opacity(0.2))
//                            .cornerRadius(8)
//                        Button("Fetch") {
//                            fetchNews()
//                        }
//                    }
//                    .padding()
//                }
//            }
//            .navigationTitle("Test")
//            .onAppear {
//                if !apiKey.isEmpty {
//                    fetchNews()
//                }
//            }
//        }
//    }
//
//    private func fetchNews() {
//        guard !apiKey.isEmpty else {
//            errorMessage = "API key is missing...."
//            return
//        }
//        
//        isLoading = true
//        errorMessage = nil
//        let apiService = NewsApiService()
//
//        apiService.fetchNews(endpoint: "https://newsapi.org/v2/top-headlines", query: "technology") { result in
//            DispatchQueue.main.async {
//                isLoading = false
//                switch result {
//                case .success(let fetchedArticles):
//                    self.articles = fetchedArticles
//                case .failure(let error):
//                    self.errorMessage = "Error: \(error.localizedDescription)"
//                }
//            }
//        }
//    }
//}
//
//#Preview {
//    APITest()
//}
