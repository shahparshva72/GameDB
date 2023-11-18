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
    let value: ScrollViewProxy
    let content: (T) -> Content

    var body: some View {
        HStack {
            Spacer()
            VStack(alignment: .center, spacing: 0) {
                ForEach(sectionIdentifiers, id: \.self) { identifier in
                    Button {
                        withAnimation {
                            value.scrollTo(identifier)
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        }
                    } label: {
                        content(identifier)
                    }
                    .contentShape(Rectangle()) 
                }
            }
        }
    }
}
