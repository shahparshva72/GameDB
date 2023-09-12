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
        }
        .onAppear {
            viewModel.fetchNews()
        }
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
