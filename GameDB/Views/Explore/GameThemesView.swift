//
//  GameThemesView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

import SwiftUI

struct GameThemesView: View {
    var body: some View {
        List(GameTheme.allCases, id: \.self) { theme in
            NavigationLink(destination: GameThemeDetailView(theme: theme)) {
                Text(theme.description)
            }
        }
        .navigationTitle("Game Themes")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct GameThemeDetailView: View {
    let theme: GameTheme
    @State private var games: [GameModel] = []
    @State private var isLoading: Bool = true
    @State private var showError: Bool = false
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
                            GameThumbnail(url: game.coverURL, name: game.name)
                                .frame(width: 155)
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
            .navigationBarTitle(Text(theme.description), displayMode: .inline)
            .onAppear {
                if games.isEmpty {
                    fetchGames(offset: currentOffset)
                }
            }
            .alert(isPresented: $showError) {
                Alert(title: Text("Error"), message: Text("There was an error fetching the games for this theme."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func loadMoreContent() {
        currentOffset += 30
        fetchGames(offset: currentOffset)
    }
    
    private func fetchGames(offset: Int) {
        APIManager.shared.gamesByThemes(for: theme, currentOffset: offset) { result in
            isLoading = false
            switch result {
            case .success(let fetchedGames):
                if fetchedGames.isEmpty {
                    areGamesAvailable = true
                } else {
                    games.append(contentsOf: fetchedGames)
                }
            case .failure:
                showError = true
            }
        }
    }
}


struct GameThemesView_Previews: PreviewProvider {
    static var previews: some View {
        GameThemesView()
    }
}
