//
//  GameThumbnail.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI

struct GameThumbnail: View {
    @StateObject private var gameManager = GameManager()
    var game: GameModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Game cover image
            if let imageURL = game.coverURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } placeholder: {
                    Rectangle()
                        .foregroundColor(Color.gray)
                }
                .cornerRadius(10)
                .shadow(radius: 5)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .contextMenu {
            if isUpcoming(game: game) {
                Button(action: {
                    gameManager.saveGame(game)
                }) {
                    Text("Save Game")
                    Image(systemName: "bookmark.fill")
                }
            }
        }
    }
    
    func isUpcoming(game: GameModel) -> Bool {
        return game.releaseDate > Date()
    }
}

