//
//  ArticleListView.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct ArticleListView: View {
    let articles: [Article]
    let archiveAction: (IndexSet) -> Void
    let addNoteAction: (Article) -> Void
    @Binding var selectedCategory: String
    let onDetailViewAppear: () -> Void
    let onDetailViewDisappear: () -> Void
    
    var body: some View {
        List {
            ForEach(articles) { article in
                NavigationLink(
                    destination: ArticleDetailView(article: article.toNewsArticle())
                        .onAppear { onDetailViewAppear() }
                        .onDisappear { onDetailViewDisappear() }
                ) {
                    VStack(alignment: .leading) {
                        HStack {
                            Text(article.title)
                                .font(.headline)
                            
                            Spacer()
                            
                            if let category = article.category {
                                Text(category.name)
                                
                                    .font(.caption)
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    .foregroundStyle(.primary)
                            }
                        }
                        
                        if let description = article.articleDescription {
                            Text(description)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                            
                            Divider()
                        }
                        
                        Text("Saved at: \(formatDate(article.savedDate))")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundStyle(.primary)
                        
                        if let note = article.note {
                            Text("Note: \(note)")
                                .font(.caption)
                                .foregroundStyle(.blue)
                        }
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(action: {
                        addNoteAction(article)
                    }) {
                        Label("Add note", systemImage: "note")
                    }
                    .tint(.blue)
                    
                    Button(role: .destructive) {
                        if let index = articles.firstIndex(of: article) {
                            archiveAction(IndexSet(integer: index))
                        }
                    } label: {
                        Label("Archive", systemImage: "archivebox")
                    }
                }
            }
        }
        .navigationTitle("Your stored articles")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                CategoryMenu(selectedCategory: $selectedCategory)
            }
        }
    }
}

func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter.string(from: date)
}
