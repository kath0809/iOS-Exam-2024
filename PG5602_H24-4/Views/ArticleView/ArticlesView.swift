//
//  ArticlesView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import SwiftUI
import SwiftData

//struct ArticlesView: View {
//    @Environment(\.modelContext) var modelContext
//    @Query(sort: \Article.savedDate, order: .reverse) var storedArticles: [Article]
//    @AppStorage("tickerPosition") private var tickerPosition: String = "Top"
//    @AppStorage("isNewsTickerActive") private var isNewsTickerActive: Bool = true
//    @State var detailedView = false
//    
//    @State var selectedCategory = "All"
//    let defaultCategories = ["Technology", "Economy", "Politics", "Sports", "News"]
//    
//    var filteredArticles: [Article] {
//        if selectedCategory == "All" {
//            return storedArticles
//        }
//        return storedArticles.filter { article in
//            if let categoryName = article.category?.name {
//                return categoryName == selectedCategory
//            }
//            return false
//        }
//    }
//    
//    var body: some View {
//        VStack {
//            if !detailedView {
//                if tickerPosition == "Top" && isNewsTickerActive {
//                    NewsTickerView()
//                        .frame(height: 50)
//                }
//            }
//            
//            NavigationView {
//                if storedArticles.isEmpty {
//                    VStack {
//                        Image(systemName: "square.stack.3d.up.slash")
//                            .resizable()
//                            .frame(width: 70, height: 70)
//                            .padding()
//                        
//                        Text("No articles are saved.")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundStyle(.primary)
//                            .padding(.bottom, 2)
//                        
//                        Text("Please go to search and fetch articles and news from the internet.")
//                            .font(.body)
//                            .foregroundStyle(.secondary)
//                            .multilineTextAlignment(.center)
//                            .padding(.horizontal, 30)
//                    }
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .background(Color(UIColor.systemBackground))
//                } else {
//                    List {
//                        ForEach(filteredArticles) { article in
//                            NavigationLink(destination: ArticleDetailView(article: article.toNewsArticle())
//                                .onAppear { detailedView = true }
//                                .onDisappear { detailedView = false }
//                            ) {
//                                VStack(alignment: .leading) {
//                                    Text(article.title)
//                                        .font(.headline)
//                                    if let description = article.articleDescription {
//                                        Text(description)
//                                            .font(.subheadline)
//                                            .foregroundStyle(.secondary)
//                                    }
//                                }
//                            }
//                        }
//                        .onDelete(perform: archiveArticle)
//                    }
//                    .navigationTitle("Your stored articles")
//                    .toolbar {
//                        ToolbarItem(placement: .navigationBarTrailing) {
//                            Menu {
//                                ForEach(defaultCategories, id: \.self) { category in
//                                    Button(action: {
//                                        selectedCategory = category
//                                    }) {
//                                        Text(category)
//                                        if selectedCategory == category {
//                                            Image(systemName: "checkmark")
//                                        }
//                                    }
//                                }
//                            } label: {
//                                Image(systemName: "ellipsis.circle")
//                                    .imageScale(.large)
//                            }
//                        }
//                    }
//                }
//            }
//            
//            if tickerPosition == "Bottom" && isNewsTickerActive {
//                NewsTickerView()
//                    .frame(height: 50)
//            }
//        }
//    }
//    
//    func archiveArticle(at offsets: IndexSet) {
//        for index in offsets {
//            let article = storedArticles[index]
//            article.isArchived = true
//        }
//        
//        saveChanges()
//    }
//    
//    func saveChanges() {
//        do {
//            try modelContext.save()
//            print("Archived article")
//        } catch {
//            print("Error archive article: \(error)")
//        }
//    }
//}

struct ArticlesView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Article.savedDate, order: .reverse) var storedArticles: [Article]
    @AppStorage("tickerPosition") var tickerPosition: String = "Top"
    @AppStorage("isNewsTickerActive") var isNewsTickerActive = true
    @State var detailedView = false

    @State var selectedCategory = "All"
    let defaultCategories = ["Technology", "Economy", "Politics", "Sports", "News"]

    var filteredArticles: [Article] {
        storedArticles.filter { article in
            !article.isArchived && (selectedCategory == "All" || article.category?.name == selectedCategory)
        }
    }

    var body: some View {
        VStack {
            if !detailedView && isNewsTickerActive && tickerPosition == "Top" {
                NewsTickerView()
                    //.frame(height: 50)
            }

            NavigationView {
                if filteredArticles.isEmpty {
                    EmptyStateView()
                } else {
                    ArticleListView(
                        articles: filteredArticles,
                        archiveAction: archiveArticle,
                        selectedCategory: $selectedCategory
                    )
                }
            }
            .onAppear { detailedView = false }

            if !detailedView && isNewsTickerActive && tickerPosition == "Bottom" {
                NewsTickerView()
                    .frame(height: 50)
            }
        }
    }

    func archiveArticle(at offsets: IndexSet) {
        for index in offsets {
            let article = filteredArticles[index]
            article.isArchived = true
        }
        saveChanges()
    }

    func saveChanges() {
        do {
            try modelContext.save()
            print("Changes saved successfully")
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}

struct ArticleListView: View {
    let articles: [Article]
    let archiveAction: (IndexSet) -> Void
    @Binding var selectedCategory: String

    var body: some View {
        List {
            ForEach(articles) { article in
                NavigationLink(destination: ArticleDetailView(article: article.toNewsArticle())) {
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        if let description = article.articleDescription {
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .onDelete(perform: archiveAction)
        }
        .navigationTitle("Your stored articles")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CategoryMenu(selectedCategory: $selectedCategory)
            }
        }
    }
}

struct CategoryMenu: View {
    @Binding var selectedCategory: String
    let categories = ["All", "Technology", "Economy", "Politics", "Sports", "News"]

    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category)
                    if selectedCategory == category {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        }
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack {
            Image(systemName: "square.stack.3d.up.slash")
                .resizable()
                .frame(width: 70, height: 70)
                .padding()

            Text("No articles are saved.")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
                .padding(.bottom, 2)

            Text("Please go to search and fetch articles and news from the internet.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}


#Preview {
    ArticlesView()
}
