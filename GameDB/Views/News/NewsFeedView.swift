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
    @State private var feedModel: FeedsModel = .verge
    
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
                        ForEach(FeedsModel.allCases, id: \.self) { feed in
                            Button {
                                feedModel = feed
                                self.viewModel.fetchNews(for: feedModel)
                            } label: {
                                Text(feed.feed.name)
                            }
                            
                        }
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }
        .onAppear{
            viewModel.fetchNews(for: feedModel)
        }
    }
}



struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
