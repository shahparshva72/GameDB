//
//  NewsFeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()
    private let shimmerCount = 10 // Fixed number of shimmer views to show

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    if viewModel.isLoading {
                        ForEach(0 ..< shimmerCount, id: \.self) { _ in
                            ShimmerView()
                                .frame(height: 200)
                                .cornerRadius(20)
                        }
                    } else {
                        ForEach(viewModel.items, id: \.id) { newsItem in
                            ZStack {
                                NewsFeedItemView(newsItem: newsItem)
                                NavigationLink(destination: NewsContentView(urlString: newsItem.link)) {
                                    EmptyView()
                                }
                                .opacity(0)
                            }
                        }
                    }
                }
                .padding()
            }
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
                    .disabled(viewModel.currentPage == 1 || viewModel.isLoading)

                    Spacer()

                    Button("Next") {
                        Task {
                            await viewModel.loadNextPage()
                        }
                    }
                    .disabled(!viewModel.hasMoreNews || viewModel.isLoading)
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
