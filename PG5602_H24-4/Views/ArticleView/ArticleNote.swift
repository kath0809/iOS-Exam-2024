//
//  ArticleNote.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 07/12/2024.
//

import SwiftUI

struct ArticleNote: View {
    var article: Article
    @Binding var noteText: String
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 20) {
                
                Text("Add Note for:")
                    .font(.headline)
                    .padding(.top)
                
                Text(article.title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.bottom)
                
                
                TextField("Enter your note here...", text: $noteText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Spacer()
                
                Button(action: onSave) {
                    Text("Save Note")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
            }
            .padding()
            .navigationTitle("Add Note")
        }
    }
}
