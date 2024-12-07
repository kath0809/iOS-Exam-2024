//
//  MainLayoutView.swift
//  PG5602_H24-4
//
//

import SwiftUI
import SwiftData

struct MainLayoutView: View {
    @Environment(\.modelContext) var modelContext
    @State var tickerTextColor: Color = .tickerText
    @State var tickerFSize: Double = 16

    var body: some View {
        TabView {
            Tab("My Artichles", systemImage: "doc.text") {
                //NewsTickerView()
                ArticlesView(
                    tickerTextColor: $tickerTextColor,
                    tickerFSize: $tickerFSize
                )
            }
            
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            
            Tab("Set up", systemImage: "gearshape") {
                SetupView(
                    tickerTextColor: $tickerTextColor,
                    tickerFSize: $tickerFSize
                )
            }
            
//            Tab("TestView", systemImage: "heart.fill") {
//                APITest()
//            }
        }
    }
}

#Preview {
    MainLayoutView()
}
