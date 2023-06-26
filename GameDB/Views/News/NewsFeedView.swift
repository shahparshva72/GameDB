//
//  NewsFeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI
import Combine

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.newsItems, id: \.link) { newsItem in
                ZStack {
                    NewsFeedItemView(newsItem: newsItem)
                    NavigationLink(destination: NewsContentView(urlString: newsItem.link)) {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .navigationTitle("News Feed")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button {
                            self.viewModel.fetchAllNews()
                        } label: {
                            Text("All")
                        }
                        Divider()
                        ForEach(viewModel.feedListModel.feeds, id: \.id) { feed in
                            Button {
                                self.viewModel.fetchNews(for: feed)
                            } label: {
                                Text(feed.name)
                            }
                        }
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
        .onAppear{
            viewModel.fetchAllNews()
        }
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
