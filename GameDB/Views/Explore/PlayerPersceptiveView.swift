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
        .navigationTitle(perspective.description)
        .onAppear(perform: fetchGames)
    }
    
    func fetchGames() {
        APIManager.shared.gamesByPlayerPerspective(for: perspective) { result in
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

struct PlayerPersceptiveView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerPersceptiveView()
    }
}
