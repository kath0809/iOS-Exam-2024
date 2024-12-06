//
//  ArticleDetailedView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 03/12/2024.
//

import SwiftUI
import SwiftData

struct ArticleDetailView: View {
    let article: NewsArticle
    @Environment(\.modelContext) var modelContext
    @State var isArticleSaved = false
    @State var isCategoryChosen = false
    @State var showMessage = false
    @State var saveMessasge = ""
    @State var selectedCategory: Category? = nil
    @State var categories: [Category] = [
        Category(name: "Technology"),
        Category(name: "Economy"),
        Category(name: "Politics"),
        Category(name: "Sports"),
        Category(name: "News"),
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                                .shadow(color: Color.gray.opacity(0.1), radius: 10)
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
                        .foregroundStyle(.gray)
                        .padding()
                }
                
                HStack {
                    if let author = article.author {
                        Text("\(author)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(article.publishedAt)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                Text(article.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.primary)
                
                if let description = article.description {
                    Text(description)
                        .font(.body)
                        .foregroundStyle(.secondary)
                }
                
                if let url = URL(string: article.url) {
                    Link("Read more", destination: url)
                        .font(.headline)
                        .foregroundStyle(.blue)
                }
            }
            .padding()
            
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: toggleSaveArticle) {
                        Image(systemName: isArticleSaved ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(isArticleSaved ? .blue : .primary)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Picker("Select Category", selection: $selectedCategory) {
                            Text("None").tag(Optional<Category>.none)
                            ForEach(categories, id: \.id) { category in
                                Text(category.name).tag(category as Category?)
                            }
                        }
                        .onChange(of: selectedCategory) { oldValue, newValue in
                            guard oldValue != newValue else { return }
                            print("Changed from \(oldValue?.name ?? "None") to \(newValue?.name ?? "None")")
                            isCategoryChosen = newValue != nil
                        }
                        
                        
                    } label: {
                        Image(systemName: isCategoryChosen ? "tag.fill" : "tag")
                            .foregroundStyle(isCategoryChosen ? .blue : .primary)
                    }
                }
                
            }
            .onAppear {
                checkIfArticleIsSaved()
                checkIfCategoryIsChosen()
                if isArticleSaved {
                    let savedArticles = Article.fetchAll(in: modelContext)
                    if let storedArticle = savedArticles.first(where: { $0.url == article.url }) {
                        selectedCategory = storedArticle.category
                    }
                }
            }
            
        }
    }

    
    func checkIfArticleIsSaved() {
        let savedArticles = Article.fetchAll(in: modelContext)
        isArticleSaved = savedArticles.contains { $0.url == article.url }
    }
    
    func checkIfCategoryIsChosen() {
        isCategoryChosen = selectedCategory != nil
    }

    func toggleSaveArticle() {
        if isArticleSaved {
            let savedArticles = Article.fetchAll(in: modelContext)
            if let storedArticle = savedArticles.first(where: { $0.url == article.url }) {
                storedArticle.deleteFromDatabase(context: modelContext)
                isArticleSaved = false
            }
        } else {
            saveArticleWithCategory()
        }
    }

    func saveArticleWithCategory() {
        let storedArticle = Article(
            article: article,
            category: selectedCategory,
            note: "Optional user note"
        )
        
        if let category = selectedCategory {
            category.articles.append(storedArticle);
            modelContext.insert(category);
        }
        
        modelContext.insert(storedArticle)
        do {
            try modelContext.save()
            isArticleSaved = true
        } catch {
            saveMessasge = "Failed to save article: \(error.localizedDescription)"
        }
        showMessage = true
    }
}