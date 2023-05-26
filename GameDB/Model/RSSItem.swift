//
//  RSSItem.swift
//  GameDB
//
//  Created by Parshva Shah on 5/24/23.
//

import Foundation

// Define your data model for the News Item.
struct RSSItem: Identifiable {
    var id: String
    var title: String
    var link: String
    var content: String
    var pubDate: Date
    var author: String
    var imageURL: String?
    
    init(id: String, title: String, link: String, content: String, pubDate: Date, author: String, imageURL: String? = nil) {
        self.id = id
        self.title = title
        self.link = link
        self.content = content
        self.pubDate = pubDate
        self.author = author
        self.imageURL = imageURL
    }
}
