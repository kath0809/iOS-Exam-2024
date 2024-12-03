//
//  Category+SwiftData.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 03/12/2024.
//

import Foundation
import SwiftData

// La brukeren velge kategori til artikkeln som lagres. Category modellen er koblet sammen med Article modellen.

extension Category {
    static func initializeDefaultCategories(in context: ModelContext) {
        let defaultCategories = ["Technology", "Economy", "Politics", "Sports", "News"]
        let existingCategories = fetchAll(in: context)
        
        for categoryName in defaultCategories {
            if !existingCategories.contains(where: { $0.name == categoryName }) {
                let newCategory = Category(name: categoryName)
                context.insert(newCategory)
            }
        }
        
        do {
            try context.save()
            print("Default categories initialized.")
        } catch {
            print("Error saving default categories: \(error.localizedDescription)")
        }
    }
    
    static func fetchAll(in context: ModelContext) -> [Category] {
        let fetchDescriptor = FetchDescriptor<Category>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching categories: \(error.localizedDescription)")
            return []
        }
    }
}


