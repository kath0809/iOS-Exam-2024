//
//  CategoryMenu.swift
//  PG5602_H24-4
//
//  Created by Karima Thingvold on 07/12/2024.
//

import SwiftUI

struct CategoryMenu: View {
    @Binding var selectedCategory: String
    let categories = ["All", "Technology", "Economy", "Politics", "Sports", "News"]
    
    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category)
                    if selectedCategory == category {
                        Image(systemName: "checkmark")
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
                .imageScale(.large)
        }
    }
}
