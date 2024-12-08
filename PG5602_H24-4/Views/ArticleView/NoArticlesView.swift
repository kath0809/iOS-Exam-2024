//
//  NoArticlesView.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct NoArticlesView: View {
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
