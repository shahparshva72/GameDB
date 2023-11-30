//
//  SavedGamesViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 10/9/23.
//

import SwiftUI
import Combine
import CoreData

class SavedGamesViewModel: ObservableObject {
    @Published var savedGames: [GameDataModel] = []
    
    var category: SaveGamesCategory
    private var cancellables = Set<AnyCancellable>()
    
    init(category: SaveGamesCategory) {
        self.category = category
        fetchData(for: category)
        
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: GameDataProvider.shared.viewContext)
            .sink { [weak self] _ in
                if GameDataProvider.shared.viewContext.hasChanges {
                    self?.fetchData(for: category)
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchData(for category: SaveGamesCategory) {
        let fetchRequest: NSFetchRequest<GameDataModel> = GameDataModel.gamesFetchRequest
        switch category {
        case .favorite:
            fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        case .played:
            fetchRequest.predicate = NSPredicate(format: "isPlayed == %@", NSNumber(value: true))
        case .toPlay:
            fetchRequest.predicate = NSPredicate(format: "isToPlay == %@", NSNumber(value: true))
        case .upcoming:
            fetchRequest.predicate = NSPredicate(format: "isUpcoming == %@", NSNumber(value: true))
        case .playing:
            fetchRequest.predicate = NSPredicate(format: "isPlaying == %@", NSNumber(value: true))
        }
        
        do {
            let games = try GameDataProvider.shared.viewContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.savedGames = games
            }
        } catch {
            print("Error fetching data for category \(category): \(error.localizedDescription)")
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
