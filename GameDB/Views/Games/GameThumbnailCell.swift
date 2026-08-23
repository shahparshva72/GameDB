//
//  GameThumbnailCell.swift
//  GameDB
//
//  Created by Parshva Shah on 11/9/23.
//

import Kingfisher
import SwiftUI

struct GameThumbnailCell: View {
    var url: URL?
    var name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            KFImage(url)
                .placeholder {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(40)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                        .accessibilityHidden(true)
                }
                .resizable()
                .aspectRatio(CGFloat(3) / CGFloat(4), contentMode: .fill)
                .frame(maxWidth: .infinity)
                .clipped()
                .background(Color(hex: "#27272A")) // Dark gray background
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2) // Border for retro feel
                )
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
                .accessibilityHidden(true)

            Text(name)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .pixelatedFont(size: 12)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
    }
}

extension DynamicTypeSize {
    var gameGridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: 16),
            count: isAccessibilitySize ? 1 : 2
        )
    }
}

struct GameThumbnailCell_Previews: PreviewProvider {
    static var previews: some View {
        GameThumbnailCell(url: URL(string: "https://www.example.com/image.jpg"), name: "Game Name")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
