//
//  GameProvider.swift
//  GameDB
//
//  Created by Parshva Shah on 10/7/23.
//

import Foundation
import CoreData
import SwiftUI

final class GameDataProvider {
    static let shared = GameDataProvider()
    
    private let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "GameDataModel")
        persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load store with error:: \(error)")
            }
        }
    }
}

extension GameDataProvider {
    func saveOrUpdateGame(id: Int, name: String, releaseDate: Date, coverURLString: String, category: SaveGamesCategory) {
        let fetchRequest: NSFetchRequest<GameDataModel> = GameDataModel.fetchRequest() as! NSFetchRequest<GameDataModel>
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        let game: GameDataModel
        
        if let existingGame = try? viewContext.fetch(fetchRequest).first {
            game = existingGame
        } else {
            game = GameDataModel(context: viewContext)
            game.id = id
            game.name = name
            game.releaseDate = releaseDate
            game.coverURLString = coverURLString
        }
        
        // Toggle the category
        switch category {
        case .played:
            game.isPlayed.toggle()
        case .toPlay:
            game.isToPlay.toggle()
        case .upcoming:
            game.isUpcoming.toggle()
        case .favorite:
            game.isFavorite.toggle()
        case .playing:
            game.isPlaying.toggle()
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error saving game: \(error.localizedDescription)")
            }
        }
    }
}


extension GameDataProvider {
    func removeGame(withId id: Int) {
        let fetchRequest: NSFetchRequest<GameDataModel> = GameDataModel.fetchRequest() as! NSFetchRequest<GameDataModel>
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let games = try viewContext.fetch(fetchRequest)
            if let gameToRemove = games.first {
                viewContext.delete(gameToRemove)
                try viewContext.save()
            } else {
                print("No game found with id \(id)")
            }
        } catch {
            print("Error fetching or deleting game: \(error.localizedDescription)")
        }
    }
}

extension GameDataProvider {
    func fetchGameById(_ id: Int) -> GameDataModel? {
        let fetchRequest: NSFetchRequest<GameDataModel> = GameDataModel.fetchRequest() as! NSFetchRequest<GameDataModel>
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results.first
        } catch {
            print("Error fetching game by id: \(error.localizedDescription)")
            return nil
        }
    }
}

extension GameDataProvider {
    func updateGameStatus(for game: GameDataModel) {
        let currentDate = Date()
        
        let twoDaysFromNow = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)!
        
        if game.releaseDate < twoDaysFromNow {
            game.isUpcoming = false
            game.isToPlay = true
        }
        
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("Error updating game status: \(error.localizedDescription)")
            }
        }
    }
}
