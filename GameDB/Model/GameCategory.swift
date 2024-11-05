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
        let baseFields = "fields name, first_release_date, id, rating, involved_companies.company.name, cover.image_id"
        let baseWhere = "platforms = \(platform.rawValue) & themes != 42"
        var additionalConditions: String
        var sortCriteria: String

        switch self {
        case .criticallyAcclaimed:
            additionalConditions = "aggregated_rating >= 85"
            sortCriteria = "rating desc"
        case .newReleases:
            additionalConditions = "first_release_date < \(unixTimestamp)"
            sortCriteria = "first_release_date desc"
        case .upcoming:
            additionalConditions = "first_release_date >= \(unixTimestamp)"
            sortCriteria = "first_release_date asc"
        case .favorites:
            additionalConditions = "rating > 70"
            sortCriteria = "follows asc"
        }

        return "\(baseFields); where (\(baseWhere) & \(additionalConditions)); sort \(sortCriteria); limit 15;"
    }
}
