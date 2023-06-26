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
        VStack(alignment: .leading) {
            if let imageURL = game.coverURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                } placeholder: {
                    Color.gray
                }
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            }
            
            VStack {
                Text(game.name)
                    .font(.caption)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(width: 155)
            .frame(minHeight: 50)
        }
        .padding(.leading, 15)
    }
}
