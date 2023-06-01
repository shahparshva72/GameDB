//
//  FeedsModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import Foundation

// TODO: - Allow users to select source feeds to get news

struct Feed {
    let name: String
    let url: String
}

enum FeedsModel: CaseIterable {
    case verge
    case ign
    case polygon
    case playstation

    var feed: Feed {
        switch self {
        case .verge:
            return Feed(name: "Verge", url: "https://www.theverge.com/rss/games/index.xml")
        case .ign:
            return Feed(name: "IGN", url: "https://www.ign.com/rss/articles/feed?tags=games")
        case .polygon:
            return Feed(name: "Polygon", url: "https://www.polygon.com/rss/index.xml")
        case .playstation:
            return Feed(name: "Playstation", url: "https://blog.playstation.com/feed/")
        }
    }
}
