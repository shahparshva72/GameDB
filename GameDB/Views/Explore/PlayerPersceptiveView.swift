//
//  PlayerPersceptiveView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

import SwiftUI

struct PlayerPersceptiveView: View {
    var body: some View {
        List(PlayerPerspective.allCases, id: \.self) { perspective in
            NavigationLink(destination: PerspectiveDetailView(perspective: perspective)) {
                Text(perspective.description)
            }
        }
        .navigationTitle("Game Perspectives")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PerspectiveDetailView: View {
    let perspective: PlayerPerspective
    @State private var games = [GameModel]()
    @State private var isLoading = false
    @State private var error: Error?
    @State private var currentOffset: Int = 0
    @State private var areGamesAvailable: Bool = true
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(gameID: game.id)) {
                            GameThumbnailCell(url: game.coverURL, name: game.name)
                        }
                    }
                    
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
                }
                .padding()
            }
            .navigationTitle(perspective.description)
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
        APIManager.shared.gamesByPlayerPerspective(for: perspective, currentOffset: offset) { result in
            isLoading = false
            switch result {
            case .success(let fetchedGames):
                if fetchedGames.isEmpty {
                    areGamesAvailable = false
                } else {
                    games.append(contentsOf: fetchedGames)
                }
            case .failure(let error):
                self.error = error
            }
        }
    }
}


struct PlayerPersceptiveView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPersceptiveView()
    }
}
