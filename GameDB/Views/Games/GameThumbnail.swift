//
//  GameThumbnail.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import Kingfisher
import SwiftUI

struct GameThumbnail: View {
    var url: URL?
    var name: String
    let thumbnailHeight: CGFloat = 200
    let thumbnailWidth: CGFloat = 155

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let safeURL = url {
                KFImage.url(safeURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            Text(name)
                .font(.headline)
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.horizontal, 5)
                .frame(width: thumbnailWidth, alignment: .leading)
        }
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
