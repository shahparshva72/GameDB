//
//  NewsAPIManager.swift
//  GameDB
//
//  Created by Parshva Shah on 10/29/23.
//

import Foundation

class NewsAPIManager {
    static let shared = NewsAPIManager()

    func fetchFeedNames() async throws -> [String] {
        guard let url = URL(string: "\(Constants.newsApiUrl)/get-feed-names") else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        let feedNames = try JSONDecoder().decode([String].self, from: data)
        return feedNames
    }

    func fetchNewsFeed(page: Int, perPage: Int) async throws -> [RSSItem] {
        let urlString = "\(Constants.newsApiUrl)/get-all-feeds?page=\(page)&per_page=\(perPage)"
        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: nil)
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        let feedItems = try JSONDecoder().decode([RSSItem].self, from: data)
        return feedItems
    }

    func fetchNewsByName(feedName: String, page: Int, perPage: Int) async throws -> RSSResponse {
        let urlString = "\(Constants.newsApiUrl)/get-feed?feed_name=\(feedName)&page=\(page)&per_page=\(perPage)"

        guard let url = URL(string: urlString) else {
            throw NSError(domain: "Invalid URL", code: 400, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "accept")

        let (data, _) = try await URLSession.shared.data(for: request)

        let rssResponse = try JSONDecoder().decode(RSSResponse.self, from: data)
        return rssResponse
    }
}
