//
//  SummaryViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 10/10/23.
//

import Foundation
import Combine
import CoreData

class SummaryViewModel: ObservableObject {
    @Published var gameCounts: [SaveGamesCategory: Int] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchAllCounts()
        
        // Observe context changes
        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: GameDataProvider.shared.viewContext)
            .sink { [weak self] _ in
                if GameDataProvider.shared.viewContext.hasChanges {
                    self?.fetchAllCounts()
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchAllCounts() {
        for category in SaveGamesCategory.allCases {
            fetchData(for: category)
        }
    }

    private func fetchData(for category: SaveGamesCategory) {
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
            let count = try GameDataProvider.shared.viewContext.count(for: fetchRequest)
            DispatchQueue.main.async {
                self.gameCounts[category] = count
            }
        } catch {
            print("Error fetching count for category \(category): \(error.localizedDescription)")
        }
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}
