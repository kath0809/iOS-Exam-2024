//
//  TopHeadlineView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

import SwiftUI

//struct TopHeadlineView: View {
//    @StateObject private var viewModel = NewsViewModel()
//    @State private var selectedCountry: String? = "us"
//    @State private var selectedCategory: String? = "technology"
//
//    var body: some View {
//        NavigationView {
//            VStack {
//                Picker("Country", selection: $selectedCountry) {
//                    Text("All Countries").tag(nil as String?)
//                    Text("United States").tag("us")
//                    Text("Norway").tag("no")
//                }.pickerStyle(SegmentedPickerStyle())
//
//                Picker("Category", selection: $selectedCategory) {
//                    Text("All Categories").tag(nil as String?)
//                    Text("Technology").tag("technology")
//                    Text("Sports").tag("sports")
//                }.pickerStyle(SegmentedPickerStyle())
//
//                List(viewModel.articles) { article in
//                    VStack(alignment: .leading) {
//                        Text(article.title).font(.headline)
//                        Text(article.description ?? "").font(.subheadline).foregroundColor(.gray)
//                    }
//                }
//            }
//            .navigationTitle("Top Headlines")
//            .task {
//                await viewModel.loadTopHeadlines(country: selectedCountry, category: selectedCategory)
//            }
//        }
//    }
//}
//
//
//#Preview {
//    TopHeadlineView()
//}
