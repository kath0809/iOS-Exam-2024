//
//  Search.swift
//  PG5602_H24-4
//
//

import Foundation
import SwiftData

@Model
class Search: Identifiable {
    @Attribute(.unique) var query: String
    var timestamp: Date

    init(query: String, timestamp: Date = Date()) {
        self.query = query
        self.timestamp = timestamp
    }
}

