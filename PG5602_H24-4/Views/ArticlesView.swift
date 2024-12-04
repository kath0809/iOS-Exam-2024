//
//  ArticlesView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

//import SwiftUI
//
//struct ArticlesView: View {
//    var body: some View {
//        VStack {
//            // HUSK å sette på "hvis artikler, vis de, hvis ikke vis dette
//            Image(systemName: "square.stack.3d.up.slash")
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: 100, height: 100)
//                .padding()
//                
//            Text("No articles are saved.")
//                .font(.title3)
//                .foregroundColor(.secondary)
//                .padding(.bottom, 2)
//            
//            Text("Please go to search and fetch articles and news from the internet.")
//                .font(.body)
//                .foregroundColor(.secondary)
//                .multilineTextAlignment(.center)
//                .padding(.horizontal, 30)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color(UIColor.systemBackground))
//    }
//}

//#Preview {
//    ArticlesView()
//}

//
//import SwiftUI
//import SwiftData
//
//struct ArticlesView: View {
//    @Query(sort: \StoredArticle.savedDate, order: .reverse) private var storedArticles: [StoredArticle]
//
//    var body: some View {
//        NavigationView {
//            List(storedArticles) { article in
//                VStack(alignment: .leading) {
//                    Text(article.title)
//                        .font(.headline)
//                    if let description = article.articleDescription {
//                        Text(description)
//                            .font(.subheadline)
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
//            .navigationTitle("Lagrede Artikler")
//        }
//    }
//}
//

import SwiftUI
import SwiftData

struct ArticlesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Article.savedDate, order: .reverse)
    var storedArticles: [Article]
    
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
//        VStack {
//            NewsTickerView()
//                .frame(height: 50)
//                .background(Color.gray.opacity(0.1))
//        }
        NavigationView {
            if storedArticles.isEmpty {
                VStack {
                    Image(systemName: "square.stack.3d.up.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
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
                    ForEach(storedArticles) { article in
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
                .navigationTitle("Lagrede Artikler")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Menu {
                            ForEach(defaultCategories, id: \.self) { category in
                                Button(action: {
                                    selectedCategory = category
                                })
                                { Text(category)
                                    if selectedCategory == category {
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    label: {
                            Image(systemName: "ellipsis.circle")
                            .imageScale(.large)
                        }
                    }
                }
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
