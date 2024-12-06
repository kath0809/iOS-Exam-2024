//
//  SetupView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import SwiftUI
import SwiftData

struct SetupView: View {
    @Environment(\.modelContext) var modelContext
    @Query(filter: #Predicate<Article> { $0.isArchived == true }) var archivedArticles: [Article]
    @AppStorage("darkmode") var isDarkMode = false
    @AppStorage("selectedCountry") var selectedCountry = "us"
    @AppStorage("selectedCategory") var selectedCategory = "All"
    @AppStorage("isNewsTickerActive") var isNewsTickerActive = true
    @AppStorage("tickerPosition") var tickerPosition = "Top"
    @AppStorage("articleCount") var articleCount = 5
    @AppStorage("apiKey") var apiKey = ""
    @State var isKeySaved = false
    
    let supportedCountries = ["All", "us", "no", "ca", "de", "fr"]
    let supportedCategories = ["All", "Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    let tickerPositions = ["Top", "Bottom"]
    
    var body: some View {
        Form {
            Section(header: Text("API Key")) {
                HStack {
                    TextField("Enter API Key...", text: $apiKey)
                        .textInputAutocapitalization(.none)
                        .autocorrectionDisabled(true)
                        .foregroundStyle(.primary)
                        .font(.body)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                    
                    Button(action: {
                        saveApiKey(apiKey)
                    }) {
                        Image(systemName: isKeySaved ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundStyle(isKeySaved ? .green : .gray)
                            .imageScale(.large)
                    }
                }
                
                if isKeySaved {
                    Text("API Key saved!")
                        .foregroundStyle(.blue)
                        .padding(.top, 8)
                }
            }
            Section(header: Text("Appearance")) {
                Toggle("Dark Mode", isOn: $isDarkMode)
                    .onChange(of: isDarkMode) { _, newValue in
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                        }
                    }
            }
            Section(header: Text("Country & Category")) {
                Picker("Country", selection: $selectedCountry) {
                    ForEach(supportedCountries, id: \.self) { country in
                        Text(country.uppercased()).tag(country)
                    }
                }
                
                Picker("Category", selection: $selectedCategory) {
                    ForEach(supportedCategories, id: \.self) { category in
                        Text(category).tag(category)
                    }
                }
            }
            Section(header: Text("News Ticker Settings")) {
                Toggle("Activate News Ticker", isOn: $isNewsTickerActive)
                Stepper("Article amount: \(articleCount)", value: $articleCount, in: 1...10)
                Picker("Position", selection: $tickerPosition) {
                    ForEach(tickerPositions, id: \.self) { position in
                        Text(position)
                    }
                }
            }
            Section(header: Text("Archived Articles")) {
                if archivedArticles.isEmpty {
                    Text("No archived articles")
                        .foregroundStyle(.secondary)
                } else {
                    VStack {
                        Text("Archived Articles: \(archivedArticles.count)")
                            .font(.headline)
                        
                        HStack {
                            Button(action: restoreAllArchivedArticles) {
                                Text("Restore")
                                    .font(.body)
                                    .foregroundStyle(.blue)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                            Button(action: deleteAllArchivedArticles) {
                                Text("Delete")
                                    .font(.body)
                                    .foregroundStyle(.red)
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                    }
                }
            }
        }
        .navigationTitle("Setup")
    }
    
    func saveApiKey(_ key: String) {
        UserDefaults.standard.set(key, forKey: "apiKey")
        isKeySaved = true
    }
    
    func restoreAllArchivedArticles() {
        for article in archivedArticles {
            article.isArchived = false
        }
        saveChanges()
    }
    
    func deleteAllArchivedArticles() {
        for article in archivedArticles {
            modelContext.delete(article)
        }
        saveChanges()
    }
    
    func saveChanges() {
        do {
            try modelContext.save()
        } catch {
            print("Error saving changes: \(error.localizedDescription)")
        }
    }
}

#Preview {
    SetupView()
}

