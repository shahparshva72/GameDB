//
//  GameCategory.swift
//  GameDB
//
//  Created by Parshva Shah on 11/18/23.
//

import Foundation

// MARK: - Home Game Filter category
enum GameCategory: String, CaseIterable {
    case criticallyAcclaimed = "Highly Rated"
    case newReleases = "New Releases"
    case upcoming = "Upcoming Games"
    case favorites = "Fan Favorites"

    func getQuery(for platform: PlatformModel) -> String {
        let unixTimestamp = Int(Date().timeIntervalSince1970)
        
        switch self {
        case .criticallyAcclaimed:
            return "fields name, first_release_date, id, rating, aggregated_rating, involved_companies.company.name, cover.image_id; where (platforms = (\(platform.rawValue)) & aggregated_rating >= 85 & themes != 42); sort rating desc; limit 15;"
        case .newReleases:
            return "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = \(platform.rawValue) & first_release_date < \(unixTimestamp)  & themes != 42); sort first_release_date desc; limit 15;"
        case .upcoming:
            return "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = \(platform.rawValue) & first_release_date >= \(unixTimestamp) & themes != 42); sort first_release_date asc; limit 15;"
        case .favorites:
            return "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id; where (platforms = \(platform.rawValue) & themes != 42); sort follows desc; limit 15;"
        }
    }
}
