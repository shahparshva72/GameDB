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

        switch category {
        case .played:
            game.isPlayed = true
        case .toPlay:
            game.isToPlay = true
        case .upcoming:
            game.isUpcoming = true
        case .favorite:
            game.isFavorite = true
        }

        do {
            try viewContext.save()
        } catch {
            print("Error saving game: \(error.localizedDescription)")
        }
    }
}
