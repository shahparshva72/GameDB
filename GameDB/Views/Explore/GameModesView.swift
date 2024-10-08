//
//  GameModesView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

import SwiftUI

struct GameModesView: View {
    var body: some View {
        List(GameMode.allCases, id: \.self) { mode in
            NavigationLink(destination: GameModeDetailView(mode: mode)) {
                Text(mode.name)
            }
        }
        .navigationTitle("Game Modes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

import SwiftUI

struct GameModeDetailView: View {
    let mode: GameMode
    @State private var games = [GameModel]()
    @State private var isLoading = true
    @State private var error: Error?
    @State private var currentOffset: Int = 0
    @State private var areGamesAvailable: Bool = true
    @EnvironmentObject var networkManager: NetworkManager

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ScrollViewReader { _ in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(gameID: game.id)) {
                            GameThumbnailCell(url: game.coverURL, name: game.name)
                        }
                    }
                }
                .padding()

                if networkManager.isConnected {
                    if isLoading && areGamesAvailable {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                            .scaleEffect(2.0)
                    } else if areGamesAvailable {
                        Text("Load More")
                            .onAppear {
                                loadMoreContent()
                            }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("No connection found.\nConnect to the internet to load games.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationTitle(mode.name)
            .onAppear {
                if games.isEmpty {
                    fetchGames(offset: currentOffset)
                }
            }
        }
    }

    private func loadMoreContent() {
        currentOffset += 30
        fetchGames(offset: currentOffset)
    }

    private func fetchGames(offset: Int) {
        isLoading = true
        APIManager.shared.gamesByModes(for: mode, currentOffset: offset) { result in
            isLoading = false
            switch result {
            case let .success(fetchedGames):
                if fetchedGames.isEmpty {
                    areGamesAvailable = false
                } else {
                    games.append(contentsOf: fetchedGames)
                }
            case let .failure(error):
                self.error = error
            }
        }
    }
}

struct GameModesView_Previews: PreviewProvider {
    static var previews: some View {
        GameModesView()
    }
}
