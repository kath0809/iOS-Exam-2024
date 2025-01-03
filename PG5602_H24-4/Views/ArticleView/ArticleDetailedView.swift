//
//  ArticleDetailedView.swift
//  PG5602_H24-4
//
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
        Category(name: "Business"),
        Category(name: "Entertainment"),
        Category(name: "General"),
        Category(name: "Health"),
        Category(name: "Science"),
        Category(name: "Sports"),
        Category(name: "Technology")
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: toggleSaveArticle) {
                        Image(systemName: isArticleSaved ? "bookmark.fill" : "bookmark")
                            .foregroundStyle(isArticleSaved ? .blue : .primary)
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
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
                            if let savedArticles = Article.fetchAll(in: modelContext).first(where: { $0.url == article.url }) {
                                updateCategory(for: savedArticles, to: newValue)
                            }
                        }
                    }
                    label: {
                        Image(systemName: isCategoryChosen ? "tag.fill" : "tag")
                            .foregroundStyle(isCategoryChosen ? .blue : .primary)
                    }
                }
            }
            .onAppear {
                checkIfArticleIsSaved()
                if isArticleSaved {
                    let savedArticles = Article.fetchAll(in: modelContext)
                    if let storedArticle = savedArticles.first(where: { $0.url == article.url }) {
                        selectedCategory = storedArticle.category
                        isCategoryChosen = selectedCategory != nil
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
            note: ""
        )
        
        if let category = selectedCategory {
            storedArticle.category = category
            category.articles.append(storedArticle)
            modelContext.insert(category)
        }
        
        modelContext.insert(storedArticle)
        do {
            try modelContext.save()
            isArticleSaved = true
            print("Article \(article.title) with category \(selectedCategory?.name ?? "") saved")
        } catch {
            saveMessasge = "Failed to save article: \(error.localizedDescription)"
        }
        showMessage = true
    }
    
    func updateCategory(for article: Article, to newCategory: Category?) {
        article.category = newCategory
        if let newCategory = newCategory {
            newCategory.articles.append(article)
            modelContext.insert(newCategory)
        }
        saveChanges()
    }
    
    func saveChanges() {
        do {
            try modelContext.save()
            print("Changed category to \(selectedCategory?.name ?? "")")
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
}


#Preview {
    ArticleDetailView(article: NewsArticle(author: "Casper", title: "Ghost Retreat", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", url: "https://i.pinimg.com/736x/5e/af/8e/5eaf8e008ac13605c48c04eff3d2f194.jpg", urlToImage: "https://i.pinimg.com/736x/5e/af/8e/5eaf8e008ac13605c48c04eff3d2f194.jpg", publishedAt: "11.29.2024"))
}
