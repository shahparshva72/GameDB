//
//  QuickScroll.swift
//  GameDB
//
//  Created by Parshva Shah on 11/13/23.
//

// ref:-  https://stackoverflow.com/questions/65185161/swiftui-how-to-add-letters-sections-and-alphabet-jumper-in-a-form

import SwiftUI

struct QuickScroll<T: Hashable, Content: View>: View {
    let sectionIdentifiers: [T]
    let proxy: ScrollViewProxy
    let content: (T) -> Content
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        HStack {
            Spacer()

            VStack(alignment: .center, spacing: 0) {
                ForEach(sectionIdentifiers, id: \.self) { identifier in
                    Button {
                        withAnimation(reduceMotion ? nil : .default) {
                            proxy.scrollTo(identifier, anchor: .top)
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    } label: {
                        content(identifier)
                    }
                    .accessibilityLabel("Jump to \(String(describing: identifier))")
                }
            }
        }
        .clipShape(Rectangle())
    }
}
