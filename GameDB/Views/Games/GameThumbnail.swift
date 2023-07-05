//
//  GameThumbnail.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI

struct GameThumbnail: View {
    var game: GameModel
    
    var body: some View {
        VStack(alignment: .leading) {
            if let imageURL = game.coverURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(Color.gray)
                        .frame(width: 155, height: 155)
                }
                .frame(width: 155, height: 155)
                .cornerRadius(10)
            }
            
            Text(game.name)
                .font(.caption)
                .foregroundColor(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 155, alignment: .leading)
        }
        .padding(.leading, 15)
        .cornerRadius(10)
    }
}
