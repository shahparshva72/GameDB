//
//  TagsView.swift
//  GameDB
//
//  Created by Parshva Shah on 11/9/23.
//

import SwiftUI

// TODO: - Future plan to add tag to platform/genre detail view

struct TagsGridView: View {
    var tagNames: [String]
    var tagColor: Color
    var tagType: TagType

    let viewModel = GamePlatformViewModel()

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(tagNames, id: \.self) { tagName in
                TagsView(name: tagName, color: tagColor)
            }
        }
    }
}

struct TagsView: View {
    var name: String
    var color: Color

    var body: some View {
        Text(name)
            .font(.subheadline)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.vertical, 5)
            .padding(.horizontal, 5)
            .frame(minWidth: 75, idealWidth: 100, maxWidth: .infinity, alignment: .center)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

enum TagType {
    case genre
    case platform
}

#Preview {
    TagsView(name: "Tag", color: .blue)
}
