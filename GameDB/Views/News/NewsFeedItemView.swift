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
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

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
                    .accessibilityHidden(true)
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
                    .font(.headline.width(.expanded))
                    .lineLimit(dynamicTypeSize.isAccessibilitySize ? nil : 2)

                if let publishedDate = newsItem.publishedDate {
                    Text(publishedDate, style: .date)
                        .font(.caption.weight(.semibold).width(.expanded))
                } else {
                    Text("Date unavailable")
                        .font(.caption.weight(.semibold).width(.expanded))
                        .foregroundColor(.gray)
                }
            }
            .foregroundColor(Color(hex: "#FAFAFA"))
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
        .background {
            ZStack {
                dominantColor
                Color.black.opacity(0.65)
            }
        }
        .cornerRadius(20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Opens the article")
    }

    private var accessibilityLabel: String {
        if let publishedDate = newsItem.publishedDate {
            return "\(newsItem.title), published \(publishedDate.formatted(date: .long, time: .omitted))"
        }
        return "\(newsItem.title), date unavailable"
    }
}
