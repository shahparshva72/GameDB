//
//  GameModel.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import Foundation

// MARK: - GameModel Definition

struct GameModel {
    // MARK: Properties

    let id: Int
    let name: String
    let storyline: String
    let summary: String
    let releaseDate: Date
    let rating: Double
    let coverURLString: String
    let screenshotURLsString: [String]
    let genres: [String]
    let company: String
    let videoIDs: [String]
    let platforms: [String]
    let aggregated_rating: Double

    var isSaved: Bool = false

    // MARK: Computed Properties

    var releaseDateText: String {
        return releaseDate.formatted(.dateTime.day().month(.wide).year())
    }

    var coverURL: URL? {
        return URL(string: coverURLString)
    }

    var genreText: String {
        return genres.joined(separator: ", ")
    }

    var screenshootURLs: [URL] {
        return screenshotURLsString.compactMap { URL(string: $0) }
    }

    var platformsText: String {
        return platforms.joined(separator: ", ")
    }
}

// MARK: - GameModel Identifiable Extension

extension GameModel: Identifiable {}
