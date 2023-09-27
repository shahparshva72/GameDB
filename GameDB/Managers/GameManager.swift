//
//  GameManager.swift
//  GameDB
//
//  Created by Parshva Shah on 9/11/23.
//

import Foundation
import Combine
import SwiftUI

// MARK: - GameManager
class GameManager: ObservableObject {
    
    // MARK: Properties
    
    @Published private var games: [GameModel] = []
    @Published private var savedGames: [GameModel] = []
    
    // MARK: Initialization
    
    init(games: [GameModel] = []) {
        self.games = games
    }
    
    // MARK: Public Functions
    
    // Fetch all games
    func getAllGames() -> [GameModel] {
        return games
    }
    
    // Save an upcoming game
    func saveGame(_ game: GameModel) {
        guard !savedGames.contains(where: { $0.id == game.id }) else { return }
        
        var gameToSave = game
        gameToSave.isSaved = true
        savedGames.append(gameToSave)
    }
    
    // Remove a saved game
    func unsaveGame(_ game: GameModel) {
        guard let index = savedGames.firstIndex(where: { $0.id == game.id }) else { return }
        
        savedGames.remove(at: index)
    }
    
    // Get saved upcoming games
    func getSavedGames() -> [GameModel] {
        return savedGames
    }
    
    // Get upcoming games based on the release date
    func getUpcomingGames() -> [GameModel] {
        let currentDate = Date()
        return games.filter { $0.releaseDate > currentDate }
    }
}
