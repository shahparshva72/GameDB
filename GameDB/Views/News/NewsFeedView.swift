//
//  NewsFeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/23.
//

import SwiftUI
import UIKit

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
            .navigationTitle("News Feed")
            .navigationBarTitleDisplayMode(.inline)
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
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Loading news")
            } else {
                List(viewModel.items, id: \.id) { newsItem in
                    NavigationLink(destination: NewsContentView(urlString: newsItem.link)) {
                        NewsFeedItemView(newsItem: newsItem)
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
                    UIAccessibility.post(
                        notification: .pageScrolled,
                        argument: "News page \(viewModel.currentPage)"
                    )
                }
            }
            .frame(minHeight: 44)
            .foregroundColor(viewModel.currentPage == 1 || viewModel.isLoading ? .gray : .primary)
            .disabled(viewModel.currentPage == 1 || viewModel.isLoading)

            Spacer()

            Button("Next") {
                Task {
                    await viewModel.loadNextPage()
                    UIAccessibility.post(
                        notification: .pageScrolled,
                        argument: "News page \(viewModel.currentPage)"
                    )
                }
            }
            .frame(minHeight: 44)
            .foregroundColor(!viewModel.hasMoreNews || viewModel.isLoading ? .gray : .primary)
            .disabled(!viewModel.hasMoreNews || viewModel.isLoading)
        }
        .pixelatedFont(size: 14)
        .padding()
        .background(.ultraThinMaterial)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("News pagination, page \(viewModel.currentPage)")
    }
}

struct NewsErrorView: View {
    let message: String
    let retryAction: () async -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "newspaper.fill")
                .font(.system(size: 50))
                .foregroundColor(.secondary)

            Text(message)
                .pixelatedFont(size: 14)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            Button(action: {
                Task {
                    await retryAction()
                }
            }) {
                Text("Try Again")
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color.accentColor)
                    .cornerRadius(10)
                    .pixelatedFont(size: 14)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct NewsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsFeedView()
    }
}
