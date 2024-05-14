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
        VStack(alignment: .leading) {
            if let safeURL = url {
                KFImage.url(safeURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                    .clipped()
                    .cornerRadius(10)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .cornerRadius(10)
    }
}
