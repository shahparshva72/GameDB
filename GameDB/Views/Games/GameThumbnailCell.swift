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
    let thumbnailHeight: CGFloat = 50
    let thumbnailWidth: CGFloat = 50

    var body: some View {
        HStack(alignment: .center) {
            if let safeURL = url {
                KFImage.url(safeURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(name)
                    .font(.headline)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
