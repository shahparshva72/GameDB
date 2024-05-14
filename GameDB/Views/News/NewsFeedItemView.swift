//
//  NewsFeedItemView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/24/23.
//

import SwiftUI
import Kingfisher

struct NewsFeedItemView: View {
    let newsItem: RSSItem
    
    @State private var dominantColor: Color = Color.white
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
                    .fontWeight(.medium)
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
            .foregroundColor(dominantUIColor.perceivedBrightness < 0.5 ? Color(hex: "#FAFAFA") : Color(hex: "#121212"))
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 8)
        .background(dominantColor.opacity(0.6))
        .cornerRadius(20)
    }
}
