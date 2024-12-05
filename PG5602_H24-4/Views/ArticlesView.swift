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
//    @State var selectedArticle: NewsArticle?
//    @State var selectedCategory = "All"
//    let defaultCategories = ["Technology", "Economy", "Politics", "Sports", "News"]
//    
//    @AppStorage("tickerPosition") var tickerPosition = "Top"
//    @AppStorage("isTickerActive") var isTickerActive = false
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
// 
//        NavigationView {
//            if storedArticles.isEmpty {
//                VStack {
//                    Image(systemName: "square.stack.3d.up.slash")
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                        .padding()
//                    
//                    Text("No articles are saved.")
//                        .font(.title)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.primary)
//                        .padding(.bottom, 2)
//                    
//                    Text("Please go to search and fetch articles and news from the internet.")
//                        .font(.body)
//                        .foregroundStyle(.secondary)
//                        .multilineTextAlignment(.center)
//                        .padding(.horizontal, 30)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(Color(UIColor.systemBackground))
//            } else {
//                List {
//                    ForEach(storedArticles) { article in
//                        NavigationLink(destination: ArticleDetailView(article: article.toNewsArticle())) {
//                            VStack(alignment: .leading) {
//                                Text(article.title)
//                                    .font(.headline)
//                                if let description = article.articleDescription {
//                                    Text(description)
//                                        .font(.subheadline)
//                                        .foregroundStyle(.secondary)
//                                }
//                            }
//                        }
//                    }
//                    .onDelete(perform: deleteArticle)
//                }
//                .navigationTitle("Your stored articles")
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) {
//                        Menu {
//                            ForEach(defaultCategories, id: \.self) { category in
//                                Button(action: {
//                                    selectedCategory = category
//                                })
//                                { Text(category)
//                                    if selectedCategory == category {
//                                        Image(systemName: "checkmark")
//                                    }
//                                }
//                            }
//                        }
//                        label: {
//                            Image(systemName: "ellipsis.circle")
//                                .imageScale(.large)
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    func deleteArticle(at offsets: IndexSet) {
//        for index in offsets {
//            let article = storedArticles[index]
//            article.deleteFromDatabase(context: modelContext)
//        }
//    }
//}


struct ArticlesView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Article.savedDate, order: .reverse) var storedArticles: [Article]
    @AppStorage("tickerPosition") private var tickerPosition: String = "Top"
    @AppStorage("isNewsTickerActive") private var isNewsTickerActive: Bool = true
    
    @State var selectedCategory = "All"
    let defaultCategories = ["Technology", "Economy", "Politics", "Sports", "News"]
    
    var filteredArticles: [Article] {
        if selectedCategory == "All" {
            return storedArticles
        }
        return storedArticles.filter { article in
            if let categoryName = article.category?.name {
                return categoryName == selectedCategory
            }
            return false
        }
    }
    
    var body: some View {
        VStack {
            if tickerPosition == "Top" && isNewsTickerActive {
                NewsTickerView()
                    .frame(height: 50)
            }
            
            NavigationView {
                if storedArticles.isEmpty {
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
                } else {
                    List {
                        ForEach(filteredArticles) { article in
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
                        .onDelete(perform: deleteArticle)
                    }
                    .navigationTitle("Your stored articles")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Menu {
                                ForEach(defaultCategories, id: \.self) { category in
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
                }
            }
            
            if tickerPosition == "Bottom" && isNewsTickerActive {
                NewsTickerView()
                    .frame(height: 50)
            }
        }
    }
    
    func deleteArticle(at offsets: IndexSet) {
        for index in offsets {
            let article = storedArticles[index]
            article.deleteFromDatabase(context: modelContext)
        }
    }
}


#Preview {
    ArticlesView()
}
