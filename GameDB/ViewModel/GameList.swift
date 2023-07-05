//
//  GameList.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import Foundation

class GameList: ObservableObject {
    
    @Published var games: [GameModel] = []
    @Published var isLoading = false
    
    func fetchGames(for platform: PlatformModel) {
        isLoading = true
        platform.fetchGames { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let games):
                    self.games = games
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
