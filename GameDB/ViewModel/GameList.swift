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
    @Published var platformName = ""
    
    
    var manager = APIManager.shared
    
    func reload(platform: PlatformModel) {
        self.games = []
        self.isLoading = true
        
        manager.getPopularGames(for: platform) { [weak self]  (result) in
            self?.isLoading = false
            
            switch result {
            case .success(let games):
                self?.games = games
                self?.platformName = platform.description
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
