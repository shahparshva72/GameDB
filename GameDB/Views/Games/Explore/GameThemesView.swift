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
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    
    var body: some View {
        List(games, id: \.id) { game in
            NavigationLink(destination: GameDetailView(gameID: game.id)) {
                Text(game.name)
            }
        }
        .onAppear(perform: loadData)
        .alert(isPresented: $showError) {
            Alert(title: Text("Error"), message: Text("There was an error fetching the games for this theme."), dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle(Text(theme.description), displayMode: .inline)
        .overlay(
            Group {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(2.0, anchor: .center)
                }
            }
        )
    }
    
    func loadData() {
        isLoading = true
        APIManager.shared.gamesByThemes(for: theme) { result in
            isLoading = false
            switch result {
            case .success(let fetchedGames):
                games = fetchedGames
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
