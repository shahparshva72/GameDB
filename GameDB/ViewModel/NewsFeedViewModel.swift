//
//  NewsFeedViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import Foundation

class NewsFeedViewModel: ObservableObject {
    @Published var items: [RSSItem] = []
    @Published var currentPage: Int = 1
    let perPage: Int = 10
        
    @MainActor
    func fetchNewsFeed() async {
        do {
            let feedItems = try await NewsAPIManager.shared.fetchNewsFeed(page: currentPage, perPage: perPage)
            DispatchQueue.main.async {
                self.items = feedItems
                
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadNextPage() async {
        currentPage += 1
        await fetchNewsFeed()
    }

    func loadPreviousPage() async {
        currentPage = max(currentPage - 1, 1)
        await fetchNewsFeed()
    }
}
