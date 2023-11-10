//
//  FavoriteGamesViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 10/9/23.
//

import SwiftUI
import CoreData

class FavoriteGamesViewModel: ObservableObject {
    @Published var favoriteGames: [GameDataModel] = []

    init() {
        fetchFavoriteGames()
    }

    func fetchFavoriteGames() {
        let fetchRequest: NSFetchRequest<GameDataModel> = GameDataModel.gamesFetchRequest
        fetchRequest.predicate = NSPredicate(format: "isFavorite == true")

        do {
            let games = try GameDataProvider.shared.viewContext.fetch(fetchRequest)
            self.favoriteGames = games
        } catch {
            print("Error fetching favorite games: \(error.localizedDescription)")
        }
    }
}
