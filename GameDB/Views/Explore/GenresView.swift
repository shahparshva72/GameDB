//
//  GenresView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

import SwiftUI

struct GenresView: View {
    var body: some View {
        List(GameGenre.allCases, id: \.self) { genre in
            NavigationLink(destination: GenreDetailView(genre: genre)) {
                Text(genre.description)
            }
        }
        .navigationTitle("Game Genres")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GenreDetailView: View {
    let genre: GameGenre
    @State private var games: [GameModel] = []
    @State private var isLoading = true
    @State private var error: Error?
    @State private var currentOffset = 0
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
            .navigationTitle(genre.description)
            .onAppear {
                fetchGames(offset: currentOffset)
            }
        }
    }
    
    private func loadMoreContent() {
        currentOffset += 30
        fetchGames(offset: currentOffset)
    }
    
    func fetchGames(offset: Int) {
        isLoading = true
        APIManager.shared.gamesByGenre(for: genre, currentOffset: offset) { result in
            switch result {
            case .success(let fetchedGames):
                games.append(contentsOf: fetchedGames)
                isLoading = false
            case .failure(let error):
                self.error = error
                isLoading = false
            }
        }
    }
}


struct GenresView_Previews: PreviewProvider {
    static var previews: some View {
        GenresView()
    }
}
