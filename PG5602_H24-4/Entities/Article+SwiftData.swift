//
//  StoredArticle+SwiftData.swift
//  PG5602_H24-4
//
//

import Foundation
import SwiftData

extension Article {
    static func fetchAll(in context: ModelContext) -> [Article] {
        let fetchDescriptor = FetchDescriptor<Article>()
        do {
            return try context.fetch(fetchDescriptor)
        } catch {
            print("Error fetching articles: \(error)")
            return []
        }
    }
    
    func saveToDatabase(context: ModelContext) {
        if let category = self.category {
            category.articles.append(self)
        }
        context.insert(self)
        do {
            try context.save()
            print("Article saved with category: \(self.category?.name ?? "None")")
        } catch {
            print("Error saving article: \(error)")
        }
    }

    
    func deleteFromDatabase(context: ModelContext) {
        context.delete(self)
        do {
            try context.save()
            print("Article deleted")
        } catch {
            print("Error deleting article: \(error)")
        }
    }
    
    func toNewsArticle() -> NewsArticle {
            return NewsArticle(
                author: self.author ?? "Unknown author",
                title: self.title,
                description: self.articleDescription ?? "No description available",
                url: self.url,
                urlToImage: self.urlToImage ?? "",
                publishedAt: self.publishedAt ?? "Unknown date"
            )
        }
}

