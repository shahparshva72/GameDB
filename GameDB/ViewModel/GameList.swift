//
//  GameList.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import Combine
import SwiftUI

struct GameListData {
    let id: Int
    let name: String
    let coverURLString: String

    var coverURL: URL? {
        return URL(string: coverURLString)
    }

    init(gameData: GameModel) {
        id = gameData.id
        name = gameData.name
        coverURLString = gameData.coverURLString
    }
}

class GameList: ObservableObject {
    @Published var games: [GameListData] = []
    @Published var isLoading = false
    private var cancellables = Set<AnyCancellable>()
    private(set) var platform: PlatformModel
    private(set) var category: GameCategory {
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

    func fetchGames() {
        isLoading = true
        APIManager.shared.getGamesByCategory(for: category, platform: platform) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case let .success(games):
                self.games = games.map {
                    GameListData(gameData: $0)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}
