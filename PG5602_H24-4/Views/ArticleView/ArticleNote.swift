//
//  ArticleNote.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct ArticleNote: View {
    var article: Article
    @Binding var noteText: String
    var onSave: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Add Note for:")
                    .font(.headline)
                    .padding(.top)
                
                Text(article.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .padding(.bottom)
                
                
                TextField("Enter note here...", text: $noteText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: onSave) {
                    Text("Save Note")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Add Note")
        }
    }
}
