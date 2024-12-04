//
//  SearchView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable {
    case relevance = "Relevance"
    case popularity = "Popularity"
    case publishedAt = "Newest"
}

struct SearchView: View {
    @Environment(\.modelContext) private var modelContext
    //@Query(sort: \Search.timestamp, order: .reverse) var searchHistory: [Search]
    //@State var searchHistory: [Search] = []

    @State var query: String = ""
    @State var articles: [NewsArticle] = []
    @State var isLoading = false
    @State var errorMessage: String?
    @State var selectedSortOption: SortOption = .relevance
    @State var selectedQuery = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundStyle(.gray)
                    TextField("Search for articles", text: $query, onCommit: {
                        search()
                    })
                    .textFieldStyle(PlainTextFieldStyle())
//                    Menu {
//                        ForEach(searchHistory) { search in
//                            Button(action: {
//                                query = search.query // Sett søkefeltet til valgt søkeord
//                                performSearch() // Utfør søket
//                            }) {
//                                Text(search.query)
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "arrowtriangle.down.fill")
//                            .foregroundColor(.blue)
//                            .padding(.horizontal, 8)
//                    }
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()
                
                HStack {
                    ForEach(SortOption.allCases, id: \.self) { option in
                        Button(action: {
                            selectedSortOption = option
                            sortArticles()
                        }) {
                            Text(option.rawValue)
                                .padding()
                                .background(selectedSortOption == option ? Color.blue : Color.gray.opacity(0.3))
                                .foregroundStyle(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                //.padding()
                            
                        }
                    }
                }
                
                if isLoading {
                    ProgressView("Loading articles")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundStyle(.red)
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
        
        newsService.searchArticles(query: query, sortBy: selectedSortOption.rawValue.lowercased()) { result in
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
    
    func sortArticles() {
        switch selectedSortOption {
        case .relevance:
            articles.sort { $0.title > $1.title }
        case .popularity:
            articles.sort { $0.author ?? "" > $1.author ?? "" }
        case .publishedAt:
            articles.sort { $0.publishedAt > $1.publishedAt }
        }
    }
    func performSearch() {
        guard !query.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        //saveSearch(query: query)
        
        let newsService = NewsApiService()
        newsService.searchArticles(query: query, sortBy: "relevance") { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success(let articles):
                    self.articles = articles
                case .failure(let error):
                    self.errorMessage = "Something went wrong: \(error.localizedDescription)"
                }
            }
        }
    }
//    func saveSearch(query: String) {
//        if !searchHistory.contains(where: { $0.query == query }) {
//            let newSearch = Search(query: query)
//            modelContext.insert(newSearch)
//        }
//    }
}

#Preview {
    SearchView()
}
