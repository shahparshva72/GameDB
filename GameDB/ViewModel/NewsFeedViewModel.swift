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
    @Published var currentPage: Int = 1
    @Published var hasMoreNews: Bool = true
    let perPage: Int = 10
    private var manager = NewsAPIManager.shared
    
    func fetchNewsFeed() async {
        do {
            let feedItems = try await manager.fetchNewsFeed(page: currentPage, perPage: perPage)
            if feedItems.isEmpty {
                hasMoreNews = false
            } else {
                items = feedItems
                hasMoreNews = true
            }
        } catch {
            print(error.localizedDescription)
            hasMoreNews = false
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
