//
//  RSSItem.swift
//  GameDB
//
//  Created by Parshva Shah on 5/24/23.
//

import Foundation

struct RSSItem: Identifiable, Codable {
    let id = UUID()
    var title: String
    var link: String
    var published: String
    var summary: String
    var image: String
    
    var linkURL: URL? {
        return URL(string: link)
    }
    
    var imageURL: URL? {
        return URL(string: image)
    }
    
    var publishedDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        return formatter.date(from: published)
    }
    
    enum CodingKeys: String, CodingKey {
        case title, link, published, summary, image
    }
}

struct RSSResponse: Codable {
    var name: String
    var total: Int
    var page: Int
    var perPage: Int
    var data: [RSSItem]

    enum CodingKeys: String, CodingKey {
        case name, total, page, data
        case perPage = "per_page"
    }
}
