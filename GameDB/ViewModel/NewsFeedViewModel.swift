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

    func fetchNews() {
        guard let url = URL(string: "https://www.theverge.com/rss/games/index.xml") else { return }
        let parser = FeedParser(URL: url)

        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            switch result {
            case .success(let feed):
                if let items = feed.atomFeed?.entries {
                    DispatchQueue.main.async {
                        var idCounter = 0
                        self.newsItems = items.compactMap { entry in
                            guard let title = entry.title,
                                  let content = entry.content?.value,
                                  let link = entry.links?.first?.attributes?.href,
                                  let pubDate = entry.published,
                                  let author = entry.authors?.first?.name else {
                                return nil
                            }

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
                        }
                    }
                }
            case .failure(let error):
                print("Parsing Failed: \(error)")
            }
        }
    }
}
