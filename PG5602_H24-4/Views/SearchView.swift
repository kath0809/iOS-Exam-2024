//
//  SearchView.swift
//  PG5602_H24-4
//
//

import SwiftUI
import SwiftData

enum SortOption: String, CaseIterable {
    case relevance = "Relevance"
    case popularity = "Popularity"
    case publishedAt = "Newest"
}

struct SearchView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Search.timestamp, order: .reverse) var searchHistory: [Search]
    @State var query: String = ""
    @State var articles: [NewsArticle] = []
    @State var isLoading = false
    @State var errorMessage: String?
    @State var selectedSortOption: SortOption = .relevance
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        TextField("Search for articles", text: $query, onCommit: {
                            performSearch()
                        })
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !searchHistory.isEmpty {
                            Menu {
                                ForEach(searchHistory) { search in
                                    Button(action: {
                                        query = search.query
                                        performSearch()
                                    }) {
                                        Text(search.query)
                                    }
                                }
                                Button(action: clearSearchHistory) {
                                    HStack {
                                        Text("Clear History")
                                            .font(.headline)
                                        Spacer()
                                        Image(systemName: "trash")
                                            .foregroundStyle(.red)
                                    }
                                    .padding(8)
                                }
                            } label: {
                                Image(systemName: "arrowtriangle.down.circle")
                                    .foregroundStyle(.blue)
                                    .imageScale(.large)
                            }
                        }
                    }
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
                            }
                        }
                    }
                    .padding()
                    
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
                if isLoading || errorMessage != nil {
                    VStack {
                        if isLoading {
                            ProgressView("Loading articles")
                                .controlSize(.large)
                                .tint(.blue)
                                .padding()
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage)
                                .foregroundStyle(.red)
                                .padding()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.4))
                    .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationTitle("Search")
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
                    self.errorMessage = "Something went wrong: \(error.localizedDescription)"
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
        
        saveSearch(query)
        
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
                    self.errorMessage = "Something went wrong: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func saveSearch(_ query: String) {
        if searchHistory.contains(where: { $0.query == query }) {
            return
        }
        let newSearch = Search(query: query)
        modelContext.insert(newSearch)
        do {
            try modelContext.save()
            print("Search saved: '\(query)'.")
        } catch {
            print("Error saving search: \(error)")
        }
    }
    func clearSearchHistory() {
        for search in searchHistory {
            modelContext.delete(search)
        }
        do {
            try modelContext.save()
            print("Search history cleared.")
        } catch {
            print("Error clearing search history: \(error)")
        }
    }
}

#Preview {
    SearchView()
}
