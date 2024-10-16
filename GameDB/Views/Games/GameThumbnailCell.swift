//
//  GameThumbnailCell.swift
//  GameDB
//
//  Created by Parshva Shah on 11/9/23.
//

import SwiftUI
import Kingfisher

struct GameThumbnailCell: View {
    var url: URL?
    var name: String
    let thumbnailHeight: CGFloat = 200
    let thumbnailWidth: CGFloat = 155

    var body: some View {
        VStack(alignment: .leading) {
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
                .clipped()
                .cornerRadius(10)
            
            Text(name)
                .font(.headline)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: thumbnailWidth)
        .cornerRadius(10)
    }
}
