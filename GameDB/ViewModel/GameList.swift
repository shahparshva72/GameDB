//
//  GameList.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import SwiftUI
import Combine

struct GameListData {
    let id: Int
    let name: String
    let coverURLString: String
    
    var coverURL: URL? {
        return URL(string: coverURLString)
    }
    
    init(gameData: GameModel) {
        self.id = gameData.id
        self.name = gameData.name
        self.coverURLString = gameData.coverURLString
    }
}

class GameList: ObservableObject {
    @Published var games: [GameListData] = []
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    var platform: PlatformModel
    var category: GameCategory {
        didSet {
            fetchGames()
        }
    }

    init(platform: PlatformModel, category: GameCategory) {
        self.platform = platform
        self.category = category
        fetchGames()
    }
    
    var platformDescription: String {
        platform.description
    }

    func updateCategory(_ category: GameCategory) {
        self.category = category
    }

    func updatePlatform(_ platform: PlatformModel) {
        self.platform = platform
        fetchGames()
    }

    func fetchGames() { // Changed to internal
        isLoading = true
        APIManager.shared.getGamesByCategory(for: category, platform: platform) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case .success(let games):
                self.games = games.map {
                    GameListData(gameData: $0)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
