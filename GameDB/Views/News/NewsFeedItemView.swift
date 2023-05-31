//
//  NewsFeedItemView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/24/23.
//

import SwiftUI

struct NewsFeedItemView: View {
    let newsItem: RSSItem
    @State private var dominantColor: Color = Color.white
    @State private var dominantUIColor: UIColor = UIColor.white

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURLString = newsItem.imageURL, let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)
                .onAppear {
                    ImageProcessing.getDominantColor(imageURLString: imageURLString) { color, uiColor in
                        dominantColor = color
                        dominantUIColor = uiColor
                    }
                }
            }
            
            Text(newsItem.title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(dominantUIColor.perceivedBrightness < 0.5 ? Color.white : Color.black)
            
            Text(newsItem.pubDate, style: .date)
                .font(.subheadline)
                .foregroundColor(dominantUIColor.perceivedBrightness < 0.5 ? Color.white : Color.black)
        }
        .padding(EdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16))
        .background(dominantColor.opacity(0.6))
        .cornerRadius(20)
        .shadow(color: dominantColor.opacity(0.3), radius: 20, x: 0.0, y: 0.0)
    }
}
