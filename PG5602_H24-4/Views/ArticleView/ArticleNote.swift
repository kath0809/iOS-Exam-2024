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
            VStack(alignment: .leading, spacing: 10) {
                
                Text("Add Note for:")
                    .font(.headline)
                    .foregroundStyle(.black)
                    .padding(.top)
                
                Text(article.title)
                    .font(.subheadline)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .padding(.bottom)
                
                TextField("Enter note here...", text: $noteText)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundStyle(.black)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: onSave) {
                    Text("Save Note")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Add Note")
            .noteBackground()
        }
    }
}

