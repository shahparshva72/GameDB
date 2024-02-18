//
//  TagsView.swift
//  GameDB
//
//  Created by Parshva Shah on 11/9/23.
//

import SwiftUI

struct TagsGridView: View {
    var tagNames: [String]
    var tagColor: Color

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
            .font(.callout)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, 5)
            .padding(.vertical, 5)
            .frame(minWidth: 75, idealWidth: 100, maxWidth: .infinity, alignment: .center)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(15)
    }
}


#Preview {
    TagsView(name: "Tag", color: .blue)
}
