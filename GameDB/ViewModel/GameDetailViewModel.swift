//
//  GameDetailViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import Combine
import SwiftUI

class GameDetailViewModel: ObservableObject {
    @Published var game: GameModel?
    @Published var isLoading = false
    @Published var error: Error?

    private var apiManager = APIManager.shared

    func fetchGame(id: Int) {
        isLoading = true
        apiManager.fetchGame(id: id) { [weak self] result in
            guard let self = self else { return }
            self.isLoading = false
            switch result {
            case let .success(game):
                self.game = game
            case let .failure(error):
                self.error = error
            }
        }
    }
}
