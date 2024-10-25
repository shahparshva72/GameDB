//
//  NewsFeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI

struct NewsFeedView: View {
    @StateObject private var viewModel = NewsFeedViewModel()
    private let shimmerCount = 10
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ScrollView {
                    if viewModel.items.isEmpty && !viewModel.isLoading {
                        NewsErrorView(message: "No news found or network error.\nPlease try again later.") {
                            await viewModel.fetchNewsFeed()
                        }
                        .frame(minHeight: geometry.size.height - 100) // Subtract some height for the navigation bar and tab bar
                    } else {
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
                }
            }
            .navigationTitle("News Feed")
            .refreshable {
                await viewModel.fetchNewsFeed()
            }
        }
        .overlay(alignment: .bottom) {
            PaginationControls(viewModel: viewModel)
        }
        .onAppear {
            Task {
                await viewModel.fetchNewsFeed()
            }
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
            
            Button(action: {
                Task {
                    await retryAction()
                }
            }) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.purple) // Match your app's accent color
                    .cornerRadius(10)
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
