//
//  NewsFeedViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import Foundation

@MainActor
class NewsFeedViewModel: ObservableObject {
    @Published var items: [RSSItem] = []
    @Published var feedNames: [String] = []
    @Published var currentPage: Int = 1
    @Published var hasMoreNews: Bool = true
    @Published var isLoading: Bool = false

    let perPage: Int = 10
    private var manager = NewsAPIManager.shared

    // Ensure fetchNewsFeed performs background work and updates UI on the main thread
    func fetchNewsFeed() async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let feedItems = try await fetchFeedItems(page: currentPage, perPage: perPage)
            await updateNewsFeed(feedItems: feedItems) // Ensure this happens on the main thread
        } catch {
            await handleError(error: error) // Handle error safely on the main thread
        }

        isLoading = false
    }

    func fetchFeedNames() async {
        do {
            let fetchedNames = try await fetchNames()
            await updateFeedNames(fetchedNames) // Update on the main thread
        } catch {
            await handleError(error: error)
        }
    }

    func fetchNewsByName(feedName: String) async {
        guard !isLoading else { return }
        isLoading = true

        do {
            let rssResponse = try await fetchNewsByName(feedName: feedName, page: currentPage, perPage: perPage)
            await updateNewsFeed(feedItems: rssResponse.data)
        } catch {
            await handleError(error: error)
        }

        isLoading = false
    }

    func loadNextPage() async {
        guard hasMoreNews && !isLoading else { return }
        currentPage += 1
        await fetchNewsFeed()
    }

    func loadPreviousPage() async {
        guard currentPage > 1 && !isLoading else { return }
        currentPage -= 1
        await fetchNewsFeed()
    }

    // Helper method to fetch feed items in the background
    private func fetchFeedItems(page: Int, perPage: Int) async throws -> [RSSItem] {
        return try await manager.fetchNewsFeed(page: page, perPage: perPage)
    }

    // Helper method to fetch names in the background
    private func fetchNames() async throws -> [String] {
        return try await manager.fetchFeedNames()
    }

    // Helper method to fetch news by name
    private func fetchNewsByName(feedName: String, page: Int, perPage: Int) async throws -> RSSResponse {
        return try await manager.fetchNewsByName(feedName: feedName, page: page, perPage: perPage)
    }

    // Update news feed data safely on the main thread
    private func updateNewsFeed(feedItems: [RSSItem]) async {
        items = feedItems
        hasMoreNews = !feedItems.isEmpty && feedItems.count == perPage
    }

    // Update feed names safely on the main thread
    private func updateFeedNames(_ names: [String]) async {
        feedNames = names
    }

    // Handle errors safely on the main thread
    private func handleError(error: Error) async {
        print("Error: \(error.localizedDescription)")
        hasMoreNews = false
    }
}
