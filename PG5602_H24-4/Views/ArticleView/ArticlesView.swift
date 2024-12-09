//
//  ArticlesView.swift
//  PG5602_H24-4
//

import SwiftUI
import SwiftData


struct ArticlesView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Article.savedDate, order: .reverse) var storedArticles: [Article]
    @AppStorage("tickerPosition") var tickerPosition: String = "Top"
    @AppStorage("isNewsTickerActive") var isNewsTickerActive: Bool = true
    @State var detailedView = false
    @State var noteText = ""
    @State var showNoteSheet = false
    @State var selectedArticle: Article?
    @State var selectedCategory = "All"
    let defaultCategories = ["Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    @Binding var tickerTextColor: Color
    @Binding var tickerFSize: Double
    
    var filteredArticles: [Article] {
        storedArticles.filter { article in
            !article.isArchived && (selectedCategory == "All" || article.category?.name == selectedCategory)
        }
    }
    
    var hasAnyArticles: Bool {
        !storedArticles.filter { !$0.isArchived }.isEmpty
    }
    
    var body: some View {
            VStack {
                if !detailedView && tickerPosition == "Top" && isNewsTickerActive {
                    NewsTickerView(
                        tickerTextColor: $tickerTextColor,
                        tickerFSize: $tickerFSize
                    )
                    .frame(height: 50)
                }
                
                NavigationView {
                    if hasAnyArticles {
                        if filteredArticles.isEmpty {
                            VStack {
                                Text("No articles with selected category:")
                                    .font(.headline)
                                    .padding()
                                Text("\(selectedCategory).")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.blue)
                                Spacer()
                            }
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    CategoryMenu(selectedCategory: $selectedCategory)
                                }
                            }
                        } else {
                            ArticleListView(
                                articles: filteredArticles,
                                archiveAction: archiveArticle,
                                addNoteAction: openNoteSheet,
                                selectedCategory: $selectedCategory,
                                onDetailViewAppear: { detailedView = true },
                                onDetailViewDisappear: { detailedView = false }
                            )
                        }
                    } else {
                        NoArticlesView()
                    }
                }
                .sheet(isPresented: Binding(
                    get: { showNoteSheet && selectedArticle != nil },
                    set: { if !$0 { showNoteSheet = false; selectedArticle = nil } }
                )) {
                    if let selectedArticle = selectedArticle {
                        ArticleNote(
                            article: selectedArticle,
                            noteText: $noteText,
                            onSave: saveNote
                        )
                    }
                }
                
                
                if !detailedView && tickerPosition == "Bottom" && isNewsTickerActive {
                    NewsTickerView(
                        tickerTextColor: $tickerTextColor,
                        tickerFSize: $tickerFSize
                    )
                    .frame(height: 50)
                }
            }
        }

    
    func archiveArticle(at offsets: IndexSet) {
        for index in offsets {
            let article = filteredArticles[index]
            article.isArchived = true
        }
        saveChanges()
    }
    
    func openNoteSheet(for article: Article) {
        selectedArticle = article
        noteText = article.note ?? ""
        print("Selected Article: \(selectedArticle?.title ?? "None")")
        print("Note Text: \(noteText)")
        showNoteSheet = true
    }
    
    
    func saveNote() {
        guard let article = selectedArticle else { return }
        article.note = noteText
        saveChanges()
        showNoteSheet = false
    }
    
    func saveChanges() {
        do {
            try modelContext.save()
            print("Changes saved successfully")
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}
