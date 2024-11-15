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
    let thumbnailHeight: CGFloat = 200
    let thumbnailWidth: CGFloat = 155

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            KFImage(url)
                .placeholder {
                    Image(systemName: "gamecontroller")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: thumbnailWidth * 0.5, height: thumbnailHeight * 0.5)
                        .foregroundColor(.gray)
                        .background(Color.gray.opacity(0.2))
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: thumbnailWidth, height: thumbnailHeight)
                .background(Color(hex: "#27272A")) // Dark gray background
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2) // Border for retro feel
                )
                .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)

            Text(name)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
                .pixelatedFont(size: 12)
                .foregroundColor(.white)
                .padding(.horizontal, 4)
        }
        .frame(width: thumbnailWidth)
        .cornerRadius(10)
    }
}

struct GameThumbnailCell_Previews: PreviewProvider {
    static var previews: some View {
        GameThumbnailCell(url: URL(string: "https://www.example.com/image.jpg"), name: "Game Name")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
