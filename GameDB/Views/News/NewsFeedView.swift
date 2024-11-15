//
//  NewsFeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                if viewModel.items.isEmpty && !viewModel.isLoading {
                    NewsErrorView(message: "No news found or network error.\nPlease try again later.") {
                        await viewModel.fetchNewsFeed()
                    }
                    .frame(minHeight: geometry.size.height - 100) // Adjust for navigation and tab bars
                } else {
                    NewsContentListView(viewModel: viewModel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("News Feed")
                        .pixelatedFont(size: 20)
                }
            }
            .refreshable {
                await viewModel.fetchNewsFeed()
            }
            .overlay(PaginationControls(viewModel: viewModel), alignment: .bottom)
            .onAppear {
                Task {
                    await viewModel.fetchNewsFeed()
                }
            }
        }
    }
}

struct NewsContentListView: View {
    @ObservedObject var viewModel: NewsFeedViewModel

    var body: some View {
        VStack(spacing: 10) {
            if viewModel.isLoading {
                ShimmerListView()
                    .padding([.horizontal, .top])
            } else {
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
            }
        }
    }
}

struct ShimmerListView: View {
    var body: some View {
        ForEach(0 ..< 10, id: \.self) { _ in
            ShimmerView()
                .frame(height: 200)
                .cornerRadius(20)
        }
    }
}

struct PaginationControls: View {
    @ObservedObject var viewModel: NewsFeedViewModel

    var body: some View {
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
        .pixelatedFont(size: 14)
        .padding()
        .background(.ultraThinMaterial)
    }
}

struct NewsErrorView: View {
    let message: String
    let retryAction: () async -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "newspaper.fill")
                .font(.system(size: 50))
                .foregroundColor(.gray)

            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .pixelatedFont(size: 14)
            
            Button(action: {
                Task {
                    await retryAction()
                }
            }) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.purple)
                    .cornerRadius(10)
                    .pixelatedFont(size: 14)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
