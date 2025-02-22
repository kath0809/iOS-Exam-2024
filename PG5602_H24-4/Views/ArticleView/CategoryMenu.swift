//
//  CategoryMenu.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct CategoryMenu: View {
    @Binding var selectedCategory: String
    let categories = [ "All","Business", "Entertainment", "General", "Health", "Science", "Sports", "Technology"]
    
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

#Preview {
    @Previewable @State var selectedCategory = "All"
    return CategoryMenu(selectedCategory: $selectedCategory)
}
