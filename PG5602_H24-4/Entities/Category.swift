//
//  Category.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 03/12/2024.
//

import Foundation
import SwiftData


@Model
class Category: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .nullify) var articles: [Article]
    var createdAt: Date
    var updatedAt: Date?

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.articles = []
        self.createdAt = Date()
        self.updatedAt = nil
    }
}


