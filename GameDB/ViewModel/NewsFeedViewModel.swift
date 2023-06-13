//
//  NewsFeedViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI
import FeedKit
import Kanna

class NewsFeedViewModel: ObservableObject {
    @Published var newsItems = [RSSItem]()
    
    func fetchAllNews() {
        for feed in FeedsModel.allCases {
            fetchNews(for: feed)
        }
    }
    
    func fetchNews(for feedModel: FeedsModel) {
        let feed = feedModel.feed
        guard let url = URL(string: feed.url) else { return }
        let parser = FeedParser(URL: url)
        
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            switch result {
            case .success(let feed):
                DispatchQueue.main.async {
                    switch feed {
                    case let .rss(rssFeed):
                        self.mapRSSItems(from: rssFeed)
                    case let .atom(atomFeed):
                        self.mapAtomItems(from: atomFeed)
                    case let .json(jsonFeed):
                        self.mapJSONItems(from: jsonFeed)
                    }
                }
            case .failure(let error):
                print("Parsing Failed: \(error)")
            }
        }
    }
    
    private func mapRSSItems(from feed: RSSFeed) {
        var idCounter = 0
        self.newsItems = feed.items?.compactMap { item in
            guard let title = item.title,
                  let link = item.link,
                  let content = item.description,
                  let pubDate = item.pubDate,
                  let author = item.dublinCore?.dcCreator else {
                return nil
            }
            
            let imageURL = item.media?.mediaContents?.first?.attributes?.url
            
            let rssItem = RSSItem(id: "\(idCounter)", title: title, link: link, content: content, pubDate: pubDate, author: author, imageURL: imageURL)
            idCounter += 1
            return rssItem
        } ?? []
    }
    
    private func mapAtomItems(from feed: AtomFeed) {
        var idCounter = 0
        self.newsItems = feed.entries?.compactMap { entry in
            guard let title = entry.title,
                  let link = entry.links?.first?.attributes?.href,
                  let content = entry.content?.value,
                  let pubDate = entry.published,
                  let author = entry.authors?.first?.name else {
                return nil
            }
            
            // Image extraction might need a similar HTML parsing step like before
            var imageURL: String? = nil
            if let html = try? HTML(html: content, encoding: .utf8) {
                for img in html.xpath("//img") {
                    if let imgSrc = img["src"], imgSrc.hasPrefix("https") {
                        imageURL = imgSrc
                        break
                    }
                }
            }
            
            let rssItem = RSSItem(id: "\(idCounter)", title: title, link: link, content: content, pubDate: pubDate, author: author, imageURL: imageURL)
            idCounter += 1
            return rssItem
        } ?? []
    }
    
    // TODO: - complete function mapJSONItems
    private func mapJSONItems(from feed: JSONFeed) {
        // Similar to mapRSSItems() but with JSONFeed's items
    }
}
