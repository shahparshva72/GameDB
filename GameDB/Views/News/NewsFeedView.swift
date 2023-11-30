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
            List(viewModel.items, id: \.id) { newsItem in
                ZStack {
                    NewsFeedItemView(newsItem: newsItem)
                    NavigationLink(destination: NewsContentView(urlString: newsItem.link)) {
                        EmptyView()
                    }
                    .opacity(0)
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            .navigationTitle("News Feed")
            .refreshable {
                await viewModel.fetchNewsFeed()
            }
            .overlay(alignment: .bottom) {
                HStack {
                    Button("Previous") {
                        Task {
                            await viewModel.loadPreviousPage()
                        }
                    }
                    .disabled(viewModel.currentPage == 1)

                    Spacer()

                    Button("Next") {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                    .disabled(!viewModel.hasMoreNews)
                }
                .padding()
                .background(.ultraThinMaterial)
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchNewsFeed()
            }
        }
    }
}


struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
