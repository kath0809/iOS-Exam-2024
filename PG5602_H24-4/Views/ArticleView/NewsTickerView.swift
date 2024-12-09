//
//  NewsTickerView.swift
//  PG5602_H24-4
//

import SwiftUI

struct NewsTickerView: View {
    @State var articles: [NewsArticle] = []
    @State var selectedArticle: NewsArticle?
    @State var tickerOffset: CGFloat = 0
    @State var isDetailedView = false
    @State var noArticlesMsg: String? = nil
    @AppStorage("selectedCountry") var selectedCountry = "us"
    @AppStorage("selectedCategory") var selectedCategory = "Technology"
    @AppStorage("isNewsTickerActive") var isNewsTickerActive = true
    @AppStorage("articleCount") var articleCount = 5
    @Binding var tickerTextColor: Color
    @Binding var tickerFSize: Double
    
    var body: some View {
        ZStack {
            if isNewsTickerActive {
                if let noArticlesMsg {
                    Text(noArticlesMsg)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    TickerView(
                        tickerTextColor: $tickerTextColor,
                        tickerFSize: $tickerFSize,
                        articles: articles,
                        tickerOffset: tickerOffset,
                        onTap: showDetails
                    )
                    .onAppear {
                        fetchTopHeadlines()
                        startTickAnimation()
                    }
                    .zIndex(0)
                }
            }
            if let article = selectedArticle {
                LargeView(article: article) {
                    withAnimation {
                        selectedArticle = nil
                    }
                }
                .zIndex(1)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5).edgesIgnoringSafeArea(.all))
                .transition(.scale)
            }
        }
        .onChange(of: selectedCountry) { oldValue, newValue in
            fetchTopHeadlines()
        }
        .onChange(of: selectedCategory) { oldValue, newValue in
            fetchTopHeadlines()
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
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedArticles):
                    if fetchedArticles.isEmpty {
                        self.noArticlesMsg = "No articles found for the selected country/category."
                        self.articles = []
                    } else {
                        self.articles = fetchedArticles
                        self.noArticlesMsg = nil
                        self.startTickAnimation()
                    }
                case .failure(let error):
                    self.noArticlesMsg = "Error fetching articles: \(error.localizedDescription)"
                }
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
    @Binding var tickerTextColor: Color
    @Binding var tickerFSize: Double
    let articles: [NewsArticle]
    let tickerOffset: CGFloat
    let onTap: (NewsArticle) -> Void
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(articles) { article in
                    Text(article.title)
                        .foregroundStyle(tickerTextColor)
                        .font(.system(size: CGFloat(tickerFSize)))
                        .lineLimit(1)
                        .padding()
                        .background(.tickerBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            onTap(article)
                        }
                }
            }
            .offset(x: tickerOffset)
            .frame(maxHeight: 50)
            Divider()
        }
    }
}

struct LargeView: View {
    let article: NewsArticle
    let onClose: () -> Void
    
    var body: some View {
        VStack {
            ZStack {
                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        }
        .transition(.scale)
    }
}

#Preview {
    NewsTickerView(
        tickerTextColor: .constant(.tickerText),
        tickerFSize: .constant(16.0)
    )
}

