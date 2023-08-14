//
//  GameModel.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import Foundation

struct GameModel {
    
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
    
}


extension GameModel: Identifiable {}
