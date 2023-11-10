//
//  GameListView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/4/23.
//

import SwiftUI

struct GameListView: View {
    @ObservedObject var gamesList: GameList

    var body: some View {
        VStack(alignment: .leading) {
            Text(gamesList.platformDescription)
                .font(.title3.bold())
                .padding(.leading, 15)
                .padding(.top, 5)

            if gamesList.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 20) {
                        ForEach(gamesList.games) { game in
                            NavigationLink(destination: GameDetailView(gameID: game.id)) {
                                GameThumbnail(url: game.coverURL, name: game.name)
                                    .frame(width: 155)
                            }
                        }
                    }
                    .padding(.leading, 15)
                }
            }
        }
    }
}

 struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(gamesList: .init(platform: .nswitch, category: .popular))
    }
 }
