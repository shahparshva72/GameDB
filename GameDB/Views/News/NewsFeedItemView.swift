//
//  NewsFeedItemView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/24/23.
//

import SwiftUI

struct NewsFeedItemView: View {
    let newsItem: RSSItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURLString = newsItem.imageURL, let imageURL = URL(string: imageURLString) {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .scaledToFit()
                .frame(height: 200)
                .cornerRadius(10)
            }
            
            Text(newsItem.title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
            
            Text(newsItem.pubDate, style: .date)
                .font(.subheadline)
        }
        .padding(.all)
        .cornerRadius(10)
        .shadow(color: .gray, radius: 5, x: 0, y: 2)
    }
}
