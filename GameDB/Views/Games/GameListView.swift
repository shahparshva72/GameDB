//
//  GameListView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/4/23.
//

import SwiftUI

struct GameListView: View {
    var platform: PlatformModel

    @StateObject var gamesList = GameList()

    var body: some View {
        VStack(alignment: .leading) {
            Text(platform.description)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 15) {
                    ForEach(gamesList.games) { game in
                        NavigationLink(destination: GameDetailView(gameID: game.id)) {
                            GameThumbnail(game: game)
                                .frame(width: 155)
                        }
                    }
                }
                .padding(.horizontal, 15)
            }
        }
        .onAppear {
            gamesList.fetchGames(for: platform)
        }
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(platform: .nswitch)
    }
}
