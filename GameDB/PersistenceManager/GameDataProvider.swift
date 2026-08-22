//
//  GameDataProvider.swift
//  GameDB
//
//  Created by Parshva Shah on 10/7/23.
//

import CoreData
import Foundation
import WidgetKit

enum WidgetConstants {
    static let upcomingGamesKind = "UpcomingGamesWidget"
}

final class GameDataProvider {
    static let shared = GameDataProvider()

    private let persistentContainer: NSPersistentContainer

    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    var newContext: NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }

    private init() {
        let container = NSPersistentContainer(name: "GameDataModel")

        // Use App Group container directory
        if let appGroupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.dev.thefourseas.GameDB") {
            let storeURL = appGroupURL.appendingPathComponent("GameDataModel.sqlite")
            let description = NSPersistentStoreDescription(url: storeURL)
            container.persistentStoreDescriptions = [description]
        } else {
            fatalError("Shared App Group container could not be created.")
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        persistentContainer = container
    }

    private func reloadUpcomingGamesWidget() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetConstants.upcomingGamesKind)
    }
}

extension GameDataProvider {
    func saveOrUpdateGame(
        id: Int,
        name: String,
        releaseDate: Date,
        coverURLString: String,
        category: SaveGamesCategory
    ) {
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
                if case .upcoming = category {
                    reloadUpcomingGamesWidget()
                }
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
                let shouldReloadWidget = gameToRemove.isUpcoming
                viewContext.delete(gameToRemove)
                try viewContext.save()
                if shouldReloadWidget {
                    reloadUpcomingGamesWidget()
                }
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
    func updateGameStatuses(for games: [GameDataModel]) {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        var didUpdateUpcomingGame = false

        for game in games where game.isUpcoming && game.releaseDate < startOfToday {
            game.isUpcoming = false
            game.isToPlay = true
            didUpdateUpcomingGame = true
        }

        guard didUpdateUpcomingGame else {
            return
        }

        do {
            try viewContext.save()
            reloadUpcomingGamesWidget()
        } catch {
            print("Error updating game statuses: \(error.localizedDescription)")
        }
    }
}
