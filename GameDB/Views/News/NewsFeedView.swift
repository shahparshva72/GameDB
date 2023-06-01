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
                    NavigationLink(destination: EmptyView()) {
                        EmptyView()
                    }
                    .opacity(0.0)
                }
            }
            .listStyle(.plain)
            .navigationTitle("News Feed")
        }
        .onAppear{
            viewModel.fetchNews(for: .ign)
        }
    }
}



struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
