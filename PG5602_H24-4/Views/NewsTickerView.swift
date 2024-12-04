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
    @State var tickPosition: TickerPosition = .top
    
    var body: some View {
        ZStack {
            if !isDetailedView {
                TickerView(articles: articles, tickerOffset: tickerOffset, onTap: showDetails)
                    .onAppear {
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
        .onAppear {
            fetchTopHeadlines()
        }
    }
    
    
    func startTickAnimation() {
        let width = CGFloat(articles.count * 300)
        let duration = Double(articles.count) * 5
        
        tickerOffset = UIScreen.main.bounds.width
 
        withAnimation(.linear(duration: duration).repeatForever(autoreverses: false)) {
            tickerOffset = -width
        }
    }
    
    func fetchTopHeadlines() {
        let apiService = NewsApiService()
        apiService.fetchTopHeadlines(country: "us", category: "sport") { result in
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
                        .foregroundStyle(.primary)
                        .font(.headline)
                        .lineLimit(1)
                        .padding()
                        //.background(Color.blue)
                        .cornerRadius(8)
                        .onTapGesture {
                            onTap(article)
                        }
                }
            }
            .offset(x: tickerOffset)
        }
        .frame(height: 50)
        .background(Color.blue)
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.opacity(0.9))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .shadow(radius: 8)
        .transition(.scale)
    }
}

#Preview {
    NewsTickerView()
}
