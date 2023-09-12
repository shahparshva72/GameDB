//
//  NewsFeedViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import Foundation
import Combine
import FeedKit
import Kanna

class NewsFeedViewModel: ObservableObject {
    
    @Published var newsItems = [RSSItem]()
    private var cancellables: Set<AnyCancellable> = []
    
    private let feedURL = URL(string: "https://www.polygon.com/rss/index.xml")!

    func fetchNews() {
        let parser = FeedParser(URL: feedURL)
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { [weak self] result in
            switch result {
            case .success(let feed):
                DispatchQueue.main.async {
                    switch feed {
                    case let .rss(rssFeed):
                        self?.mapRSSItems(from: rssFeed)
                    case let .atom(atomFeed):
                        self?.mapAtomItems(from: atomFeed)
                    case let .json(jsonFeed):
                        self?.mapJSONItems(from: jsonFeed)
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
            
            let imageURL = item.media?.mediaThumbnails?.first?.attributes?.url
            
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
    
    private func mapJSONItems(from feed: JSONFeed) {
        var idCounter = 0
        self.newsItems = feed.items?.compactMap { item in
            guard let title = item.title,
                  let link = item.url,
                  let content = item.contentText ?? item.contentHtml,
                  let pubDate = item.datePublished,
                  let author = item.author?.name else {
                return nil
            }
            
            let imageURL = item.attachments?.first(where: { $0.mimeType?.starts(with: "image/") ?? false })?.url
            
            let rssItem = RSSItem(id: "\(idCounter)", title: title, link: link, content: content, pubDate: pubDate, author: author, imageURL: imageURL)
            idCounter += 1
            return rssItem
        } ?? []
    }
}
