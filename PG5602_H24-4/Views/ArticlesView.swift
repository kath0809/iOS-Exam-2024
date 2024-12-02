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
    @Query(sort: \StoredArticle.savedDate, order: .reverse) private var storedArticles: [StoredArticle]

    var body: some View {
        NavigationView {
            if storedArticles.isEmpty {
                // Ingen artikler lagret
                VStack {
                    Image(systemName: "square.stack.3d.up.slash")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    Text("No articles are saved.")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)
                    
                    Text("Please go to search and fetch articles and news from the internet.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
            } else {
                // Vis lagrede artikler
                List(storedArticles) { article in
                    VStack(alignment: .leading) {
                        Text(article.title)
                            .font(.headline)
                        if let description = article.articleDescription {
                            Text(description)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .navigationTitle("Lagrede Artikler")
            }
        }
    }
}

