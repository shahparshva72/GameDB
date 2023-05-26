//
//  GameDetailViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI
import Combine

class GameDetailViewModel: ObservableObject {
    @Published var game: GameModel?
    @Published var isLoading = false
    @Published var error: Error?

    private var apiManager = APIManager.shared

    func fetchGame(id: Int) {
        isLoading = true
        apiManager.fetchGame(id: id) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let game):
                self?.game = game
            case .failure(let error):
                self?.error = error
            }
        }
    }
}
