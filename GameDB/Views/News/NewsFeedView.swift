//
//  NewsFeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI
import Combine
import WebKit

// The News Feed View
struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.newsItems, id: \.link) { newsItem in
                NavigationLink(destination: EmptyView()) {
                    NewsFeedItemView(newsItem: newsItem)
                }
            }
            .listStyle(.plain)
            .navigationTitle("News Feed")
        }
        .onAppear(perform: viewModel.fetchNews)
    }
}



struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
