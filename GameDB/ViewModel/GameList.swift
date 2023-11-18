//
//  GameList.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import Foundation
import Combine

class GameList: ObservableObject {
    @Published var games: [GameModel] = []
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private let platform: PlatformModel
    private var category: GameCategory {
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

    private func fetchGames() {
        isLoading = true
        APIManager.shared.getGamesByCategory(for: category, platform: platform) { [weak self] result in
            guard let self = self else { return }
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
