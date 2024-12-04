//
//  MainLayoutView.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct MainLayoutView: View {
    var body: some View {
        TabView {
            Tab("My Artichles", systemImage: "doc.text") {
                NewsTickerView()
                ArticlesView()
            }
            Tab("Search", systemImage: "magnifyingglass") {
                SearchView()
            }
            Tab("Set up", systemImage: "gearshape") {
                SetupView()
            }
        }
    }
}

#Preview {
    MainLayoutView()
}
