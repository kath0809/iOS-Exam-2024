//
//  SearchView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State var query: String = ""
    @State var articles: [NewsArticle] = []
    @State var isLoading: Bool = false
    @State var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search for articles", text: $query, onCommit: {
                        search()
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                
                if isLoading {
                    ProgressView("Loading articles")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    List(articles, id: \.url) { article in
                        NavigationLink(destination: ArticleDetailView(article: article)) {
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.description ?? "No description available")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("News search")
            
        }
    }
    
    func search() {
        guard !query.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        let newsService = NewsApiService()
        
        newsService.searchArticles(query: query) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let articles):
                    self.articles = articles
                case .failure(let error):
                    self.errorMessage = "Noe gikk galt: \(error.localizedDescription)"
                }
            }
        }
    }
}

#Preview {
    SearchView()
}
