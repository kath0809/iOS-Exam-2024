//
//  PG5602_H24_4App.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 25/11/2024.
//

import SwiftUI
import SwiftData

@main
struct PG5602_H24_4App: App {
    var sharedModelContainer: ModelContainer = {
        do {
            let schema = Schema([Article.self, Category.self, Country.self])
            return try ModelContainer(for: schema)
        } catch {
            fatalError("Could not create model container: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            SplashScreen()
                .modelContainer(sharedModelContainer)
        }
    }
}
