//
//  NewsTickerView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 04/12/2024.
//

import SwiftUI

struct NewsTickerView: View {
    @State var articles: [NewsArticle] = []
    @State var selectedArticle: NewsArticle?
    @State var tickerOffset: CGFloat = 0
    @State var isDetailedView = false
    @AppStorage("selectedCountry") var selectedCountry = "us"
    @AppStorage("selectedCategory") var selectedCategory = "technology"
    @AppStorage("isNewsTickerActive") var isNewsTickerActive = true
    @AppStorage("articleCount") var articleCount = 5
    
    var body: some View {
            if isNewsTickerActive {
                TickerView(articles: articles, tickerOffset: tickerOffset, onTap: showDetails)
                    .onAppear {
                        fetchTopHeadlines()
                        startTickAnimation()
                    }
            }
        if let article = selectedArticle {
            LargeView(article: article) {
                withAnimation {
                    selectedArticle = nil
                }
            }
        }
    }

        func startTickAnimation() {
            let width = CGFloat(articles.count) * 700
            let duration = Double(articles.count) * 5

            tickerOffset = UIScreen.main.bounds.width

            withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
                tickerOffset = -width
            }
        }

        func fetchTopHeadlines() {
            let apiService = NewsApiService()
            let country = selectedCountry == "us" ? nil : selectedCountry
            let category = selectedCategory == "technology" ? nil : selectedCategory

            apiService.fetchTopHeadlines(country: country, category: category, pageSize: articleCount) { result in
                switch result {
                case .success(let fetchedArticles):
                    DispatchQueue.main.async {
                        self.articles = fetchedArticles
                        self.startTickAnimation()
                    }
                case .failure(let error):
                    print("Error fetching top news: \(error.localizedDescription)")
                }
            }
        }
    
    func showDetails(article: NewsArticle) {
        withAnimation {
            selectedArticle = article
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                selectedArticle = nil
            }
        }
    }
}

struct TickerView: View {
    let articles: [NewsArticle]
    let tickerOffset: CGFloat
    let onTap: (NewsArticle) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(articles) { article in
                    Text(article.title)
                        .foregroundStyle(.tickerText)
                        .font(.headline)
                        .lineLimit(1)
                        .padding()
                        .background(.tickerBackground)
                        .cornerRadius(10)
                        .onTapGesture {
                            onTap(article)
                        }
                }
            }
            .offset(x: tickerOffset)
        }
    }
}

struct LargeView: View {
    let article: NewsArticle
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            Text(article.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.primary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.3),ignoresSafeAreaEdges: .all)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .transition(.scale)
    }
}

#Preview {
    NewsTickerView()
}