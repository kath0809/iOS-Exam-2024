//
//  SearchView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
    @State private var articles: [Article] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                // Søketekstfeltet med forstørrelsesglass
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Søk etter artikler...", text: $query, onCommit: {
                        search() // Starter søket når brukeren trykker "Enter"
                    })
                    .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding()

                if isLoading {
                    ProgressView("Laster inn artikler...")
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
                                Text(article.description ?? "Ingen beskrivelse tilgjengelig")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Nyhetsøk")
        }
    }

    private func search() {
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

struct ArticleDetailView: View {
    let article: Article
    @Environment(\.modelContext) private var modelContext
    @State private var isArticleSaved: Bool = false

    func saveArticle() {
        guard !isArticleSaved else { return }
        let storedArticle = StoredArticle(article: article)
        
        do {
            modelContext.insert(storedArticle)
            try modelContext.save()
            isArticleSaved = true
            print("Saved article")
        } catch {
            print("Error saving article: \(error)")
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Viser bildet
                if let urlString = article.urlToImage, let url = URL(string: urlString) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                            
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.gray)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .foregroundColor(.gray)
                        .padding()
                }

                // Tittel
                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                // Beskrivelse
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }

                // Lenke for å lese mer
                if let url = URL(string: article.url) {
                    Link("Les mer", destination: url)
                        .font(.headline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
        .navigationTitle("Artikkeldetaljer")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: saveArticle) {
                    Image(systemName: isArticleSaved ? "bookmark.fill" : "bookmark")
                        .foregroundColor(isArticleSaved ? .blue : .primary)
                }
                .accessibilityLabel("Lagre artikkel")
            }
        }
    }
}



#Preview {
    SearchView()
}
