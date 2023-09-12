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

struct GameModeDetailView: View {
    let mode: GameMode
    @State private var games = [GameModel]()
    @State private var loading = true
    @State private var error: Error?

    var body: some View {
        List {
            if loading {
                HStack {
                    Spacer()
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                }
            } else if let error = error {
                Text("Error: \(error.localizedDescription)")
                    .foregroundColor(.red)
                
            } else {
                ForEach(games) { game in
                    NavigationLink(destination: GameDetailView(gameID: game.id)) {
                        Text(game.name)
                    }
                }
            }
        }
        .navigationTitle(mode.name)
        .onAppear(perform: fetchGames)
    }

    func fetchGames() {
        APIManager.shared.gamesByModes(for: mode) { result in
            switch result {
            case .success(let fetchedGames):
                self.games = fetchedGames
                self.loading = false
                
            case .failure(let error):
                self.error = error
                self.loading = false
            }
        }
    }
}

struct GameModesView_Previews: PreviewProvider {
    static var previews: some View {
        GameModesView()
    }
}