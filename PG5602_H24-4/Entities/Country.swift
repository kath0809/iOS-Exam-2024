//
//  Country.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 03/12/2024.
//

import Foundation
import SwiftData

@Model
class Country: Identifiable {
    @Attribute(.unique) var id: UUID
    var isoCode: String
    var name: String
    
    init(id: UUID = UUID(), isoCode: String, name: String) {
        self.id = id
        self.isoCode = isoCode
        self.name = name
    }
    
}
