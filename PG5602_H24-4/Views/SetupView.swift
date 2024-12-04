//
//  SetupView.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 01/12/2024.
//

import Foundation
import SwiftUI

enum TickerPosition: String, CaseIterable {
    case top = "Top"
    case bottom = "Bottom"
}

struct SetupView: View {
    @State private var darkMode = false
    @State private var fontColor: Color = .white
    @State private var fontSize: CGFloat = 12
    @State private var selectedCountry = ""
    @State private var preferedCountry: String = UserDefaults.standard.string(forKey: "preferedCountry") ?? ""
    @State private var selectedCategory = ""
    @State private var preferedCategory: String = UserDefaults.standard.string(forKey: "preferedCategory") ?? ""
    @State private var newsItem = 5
    @State private var tickerPosition: TickerPosition = .top
    @State private var isNewsTickerActive = false

    var body: some View {
        Form {
            Section(header: Text("Country & Category")) {
                TextField("Enter country", text: $selectedCountry)
                TextField("Enter category", text: $selectedCategory)
                Button("Save Country and Category") {
                    saveCountryAndCategory(country: selectedCountry, category: selectedCategory)
                }
                
                Picker("Preferred Country", selection: $preferedCountry) {
                    Text("None").tag("")
                    Text("Norway").tag("Norway")
                    Text("USA").tag("USA")
                    Text("Canada").tag("Canada")
                }
                
                Picker("Preferred Category", selection: $preferedCategory) {
                    Text("None").tag("")
                    Text("Technology").tag("Technology")
                    Text("Sports").tag("Sports")
                }
            }
            
            Section(header: Text("News Ticker Settings")) {
                Stepper("Number of News Items: \(newsItem)", value: $newsItem, in: 1...10)
                
                Picker("Ticker Position", selection: $tickerPosition) {
                    ForEach(TickerPosition.allCases, id: \.self) { position in
                        Text(position.rawValue).tag(position)
                    }
                }
                
                Toggle("Activate News Ticker", isOn: $isNewsTickerActive)
            }
            
            Section(header: Text("Appearance")) {
                Stepper("Font Size: \(Int(fontSize))", value: $fontSize, in: 10...30)
                ColorPicker("Text Color", selection: $fontColor)
                Toggle("Dark Mode", isOn: $darkMode)
                    .onChange(of: darkMode) { oldValue, newValue in
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            windowScene.windows.first?.overrideUserInterfaceStyle = newValue ? .dark : .light
                        }
                    }
            }
        }
    }
    
    private func saveCountryAndCategory(country: String, category: String) {
        UserDefaults.standard.set(country, forKey: "preferedCountry")
        UserDefaults.standard.set(category, forKey: "preferedCategory")
    }
}

#Preview {
    SetupView()
}

