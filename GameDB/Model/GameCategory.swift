//
//  GameCategory.swift
//  GameDB
//
//  Created by Parshva Shah on 11/18/23.
//

import Foundation

// MARK: - Home Game Filter category
enum GameCategory: String, CaseIterable {
    case CriticallyAcclaimed = "Critically Acclaimed"
    case NewReleases = "New Releases"
    case upcomingGames = "Upcoming Games"
    case FanFavorites = "Fan Favorites"

    func getQuery(for platform: PlatformModel) -> String {
        let unixTimestamp = Int(Date().timeIntervalSince1970)
        switch self {
        case .CriticallyAcclaimed:
            return "fields name, first_release_date, id, rating, aggregated_rating, involved_companies.company.name, cover.image_id; where (platforms = (\(platform.rawValue)) & aggregated_rating >= 85 & themes != 42); sort rating desc; limit 10;"
        case .NewReleases:
            return "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = \(platform.rawValue) & first_release_date < \(unixTimestamp)); sort first_release_date desc; limit 10;"
        case .upcomingGames:
            return "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = \(platform.rawValue) & first_release_date >= \(unixTimestamp)); sort first_release_date asc; limit 10;"
        case .FanFavorites:
            return "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = \(platform.rawValue)); sort follows desc; limit 10;"
        }
    }
}
