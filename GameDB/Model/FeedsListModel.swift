//
//  FeedsListModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/16/23.
//

import Foundation
import Combine

struct Feed: Decodable {
    let name: String
    let url: String
}

class FeedListModel: ObservableObject {
    @Published var feeds: [Feed] = []

    init() {
        do {
            // Get the file URL
            guard let fileUrl = Bundle.main.url(forResource: "valid_feeds", withExtension: "json") else {
                fatalError("rss_data.json not found")
            }
            // Read the file data
            let jsonData = try Data(contentsOf: fileUrl)
            
            // Decode the JSON data into an array of Feed objects
            let decoder = JSONDecoder()
            let feeds = try decoder.decode([Feed].self, from: jsonData)

            // Replace the selected feeds with the decoded feeds
            self.feeds = feeds
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
