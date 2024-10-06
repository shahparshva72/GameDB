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
    let perPage: Int = 10
    private var manager = NewsAPIManager.shared
    @Published var isLoading: Bool = false

    func fetchNewsFeed() async {
        DispatchQueue.main.async {
            self.isLoading = true
        }
        do {
            let feedItems = try await manager.fetchNewsFeed(page: currentPage, perPage: perPage)
            DispatchQueue.main.async {
                if feedItems.isEmpty {
                    self.hasMoreNews = false
                } else {
                    self.items = feedItems
                    self.hasMoreNews = true
                }
                self.isLoading = false
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.hasMoreNews = false
                self.isLoading = false
            }
        }
    }

    func fetchFeedNames() async {
        do {
            let fetchedNames = try await manager.fetchFeedNames()
            DispatchQueue.main.async {
                self.feedNames = fetchedNames
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func fetchNewsByName(feedName: String) async {
        do {
            let rssResponse = try await manager.fetchNewsByName(feedName: feedName, page: currentPage, perPage: perPage)
            DispatchQueue.main.async {
                if rssResponse.data.isEmpty {
                    self.hasMoreNews = false
                } else {
                    self.items = rssResponse.data
                    self.hasMoreNews = true
                }
            }
        } catch {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                self.hasMoreNews = false
            }
        }
    }

    func loadNextPage() async {
        guard hasMoreNews else { return }
        currentPage += 1
        await fetchNewsFeed()
    }

    func loadPreviousPage() async {
        currentPage = max(currentPage - 1, 1)
        await fetchNewsFeed()
    }
}
