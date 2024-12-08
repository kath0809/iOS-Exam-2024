//
//  View+Background.swift
//  PG5602_H24-4
//
//

import SwiftUI

struct NoteBackground: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .topLeading, endPoint: .bottomTrailing)
            )
    }
}

extension View {
    func noteBackground() -> some View {
        self.modifier(NoteBackground())
    }
}


#Preview {
    VStack {
        Text("Hello, World!")
    }
    .noteBackground()
}
