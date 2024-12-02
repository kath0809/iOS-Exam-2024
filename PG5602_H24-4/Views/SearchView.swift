//
//  SearchView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import SwiftUI

struct SearchView: View {
    @State private var query: String = ""
        @State private var articles: [Article] = []
        @State private var isLoading: Bool = false
        @State private var errorMessage: String?

        var body: some View {
            NavigationView {
                VStack {
                    // Søketekstfeltet
                    TextField("Søk etter artikler...", text: $query, onCommit: {
                        search() // Starter søket når brukeren trykker "Enter"
                    })
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                    Button(action: {
                        search() // Starter søket når brukeren trykker på knappen
                    }) {
                        Text("Søk")
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .padding()

                    if isLoading {
                        ProgressView("Laster inn artikler...")
                            .padding()
                    } else if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else {
                        List(articles, id: \.url) { article in
                            VStack(alignment: .leading) {
                                Text(article.title)
                                    .font(.headline)
                                Text(article.description ?? "Ingen beskrivelse tilgjengelig")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }

                    }
                }
                .navigationTitle("Nyhetsøk")
            }
        }

        private func search() {
            guard !query.isEmpty else { return }

            // Start søkefunksjonen
            isLoading = true
            errorMessage = nil

            let newsService = NewsApiService()

            newsService.searchArticles(query: query) { result in
                DispatchQueue.main.async {
                    isLoading = false
                    switch result {
                    case .success(let articles):
                        self.articles = articles
                    case .failure(let error):
                        self.errorMessage = "Noe gikk galt: \(error.localizedDescription)"
                    }
                }
            }
        }
    }

#Preview {
    SearchView()
}
