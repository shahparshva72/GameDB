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
        .navigationTitle(genre.description)
        .onAppear(perform: fetchGames)
    }
    
    func fetchGames() {
        APIManager.shared.gamesByGenre(for: genre) { result in
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

struct GenresView_Previews: PreviewProvider {
    static var previews: some View {
        GenresView()
    }
}
