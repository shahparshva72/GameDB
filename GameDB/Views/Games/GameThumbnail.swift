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
        VStack {
            AsyncImage(url: game.coverURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            .cornerRadius(15)
            .shadow(color: dominantColor, radius: 10, x: 0.0, y: 0.0)
            .onAppear {
                ImageProcessing.getDominantColor(imageURLString: game.coverURLString) { color, uiColor in
                    dominantColor = color
                    dominantUIColor = uiColor
                }
            }
            
            HStack(alignment: .top){
                VStack(alignment: .leading) {
                    Text(game.name)
                        .font(.headline)
                    Text(game.releaseDateText)
                        .font(.subheadline)
                    Text(game.company)
                        .font(.subheadline)
                }
                .foregroundColor(dominantUIColor.perceivedBrightness < 0.5 ? Color.white : Color.black)
            }
            .frame(maxWidth: .infinity, alignment: .bottomLeading)
            .padding(EdgeInsets.init(top: 16, leading: 16, bottom: 16, trailing: 16))
            .background(Rectangle()
                .foregroundColor(dominantColor)
                .opacity(0.6)
                .blur(radius: 2.5))
        }
        .padding(10)
        .background(dominantColor)
        .cornerRadius(20)
        .shadow(color: dominantColor.opacity(0.3), radius: 20, x: 0.0, y: 0.0)
    }
}
