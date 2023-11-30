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

            if gamesList.isLoading {
                VStack {
                    Text("Loading games...")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if gamesList.games.isEmpty {
                Text("No games found.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
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
                }
                .transition(AnyTransition.opacity.combined(with: .move(edge: .trailing)).animation(.easeInOut(duration: 0.8)))
            }
        }
        .padding(.leading, 15)
        .padding(.top, 5)
    }
}

 struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(gamesList: .init(platform: .nswitch, category: .CriticallyAcclaimed))
    }
 }
