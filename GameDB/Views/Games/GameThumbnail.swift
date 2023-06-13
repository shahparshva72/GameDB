//
//  GameThumbnail.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI

struct GameThumbnail: View {
    var game: GameModel
    @State private var dominantColor: Color = Color.white
    @State private var dominantUIColor: UIColor = UIColor.white
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let imageURL = game.coverURL {
                AsyncImage(url: imageURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    ProgressView()
                }
                .clipShape(TopCornerRounded(radius: 10))
                .onAppear {
                    ImageProcessing.getDominantColor(imageURLString: game.coverURLString) { color, uiColor in
                        dominantColor = color
                        dominantUIColor = uiColor
                    }
                }
            }
            
            VStack(alignment: .leading, spacing: 8.0) {
                Text(game.name)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(game.releaseDateText)
                    .font(.subheadline)
                    
                Text(game.company)
                    .font(.subheadline)
            }
            .foregroundColor(dominantUIColor.perceivedBrightness < 0.5 ? Color.white : Color.black)
            .padding(.horizontal, 16)
        }
        .padding(.bottom, 16)
        .background(dominantColor.opacity(0.6))
        .cornerRadius(20)
        .shadow(color: dominantColor.opacity(0.3), radius: 20, x: 0.0, y: 0.0)
    }
}
