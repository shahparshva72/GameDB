//
//  GameListView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/4/23.
//

import SwiftUI

struct GameListView: View {
    @ObservedObject var gamesList: GameList
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(alignment: .leading) {
            if gamesList.isLoading {
                VStack {
                    Spacer()
                    Text("Loading games...")
                        .pixelatedFont(size: 12)
                        .foregroundColor(.gray)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.clear)
            } else if gamesList.games.isEmpty {
                Text("No games found. Refresh to retry if an error.")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .center) {
                        ForEach(gamesList.games, id: \.id) { game in
                            NavigationLink(destination: GameDetailView(gameID: game.id)) {
                                GameThumbnail(url: game.coverURL, name: game.name)
                            }
                        }
                    }
                }
                .transition(
                    reduceMotion
                        ? .opacity
                        : .opacity.combined(with: .move(edge: .trailing))
                )
            }
        }
        .pixelatedFont(size: 12)
        .padding(.top, 5)
    }
}

struct GameListView_Previews: PreviewProvider {
    static var previews: some View {
        GameListView(gamesList: .init(platform: .nswitch, category: .criticallyAcclaimed))
    }
}
