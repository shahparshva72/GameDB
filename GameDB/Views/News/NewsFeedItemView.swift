//
//  NewsFeedItemView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/24/23.
//

import Kingfisher
import SwiftUI

struct NewsFeedItemView: View {
    let newsItem: RSSItem

    @State private var dominantColor: Color = .white
    @State private var dominantUIColor: UIColor = .clear

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack {
                KFImage.url(newsItem.imageURL)
                    .placeholder {
                        ProgressView()
                    }
                    .loadDiskFileSynchronously()
                    .cacheMemoryOnly()
                    .fade(duration: 0.25)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onAppear {
                        ImageProcessing.getDominantColor(imageURLString: newsItem.image) { color, uiColor in
                            dominantColor = color
                            dominantUIColor = uiColor
                        }
                    }
            }
            .frame(maxWidth: .infinity, maxHeight: 200)
            .clipShape(TopCornerRounded(radius: 10))

            VStack(alignment: .leading, spacing: 8.0) {
                Text(newsItem.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)

                if let publishedDate = newsItem.publishedDate {
                    Text(publishedDate, style: .date)
                        .font(.caption)
                } else {
                    Text("Date unavailable")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .foregroundColor(Color(hex: "#FAFAFA"))
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
        .background(dominantColor.opacity(0.6))
        .cornerRadius(20)
    }
}
