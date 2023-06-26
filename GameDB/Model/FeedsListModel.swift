//
//  FeedsListModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/16/23.
//

import Foundation

struct Feed {
    var id = UUID()
    let name: String
    let url: String
}

class FeedListModel: ObservableObject {
    @Published var feeds: [Feed]

    init() {
        // initialize with default feeds
        feeds = [
            Feed(name: "Verge", url: "https://www.theverge.com/rss/games/index.xml"),
            Feed(name: "IGN", url: "https://www.ign.com/rss/articles/feed?tags=games"),
            Feed(name: "Polygon", url: "https://www.polygon.com/rss/index.xml"),
            Feed(name: "Playstation", url: "https://blog.playstation.com/feed/")
        ]
    }
    
    func addFeed(name: String, url: String) {
        let newFeed = Feed(id: UUID(), name: name, url: url)
        feeds.append(newFeed)
    }
    
    func removeFeed(id: UUID) {
        feeds.removeAll { $0.id == id }
    }
}
