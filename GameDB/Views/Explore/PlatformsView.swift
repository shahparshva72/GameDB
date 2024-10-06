//
//  PlatformsView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

// ref:-  https://stackoverflow.com/questions/65185161/swiftui-how-to-add-letters-sections-and-alphabet-jumper-in-a-form

import Combine
import SwiftUI

struct PlatformsView: View {
    @StateObject var viewModel = GamePlatformViewModel()

    private var sectionIdentifiers: [String] {
        Set(viewModel.platforms.map { String($0.name.prefix(1)) }).sorted()
    }

    var body: some View {
        ScrollViewReader { proxy in
            VStack {
                if viewModel.searchText.isEmpty {
                    List(sectionIdentifiers, id: \.self) { id in
                        Section {
                            ForEach(filteredPlatforms(for: id), id: \.id) { platform in
                                NavigationLink(destination: PlatformGamesView(platform: platform)) {
                                    Text(platform.name)
                                }
                            }
                            .id(id)
                        } header: {
                            Text(id)
                        }
                    }
                    .padding(.trailing, 5)
                    .listStyle(.insetGrouped)
                    .overlay(alignment: .trailing) {
                        QuickScroll(sectionIdentifiers: sectionIdentifiers, proxy: proxy) { item in
                            Text(item)
                        }
                    }
                } else {
                    List(viewModel.platforms, id: \.id) { platform in
                        NavigationLink(destination: PlatformGamesView(platform: platform)) {
                            Text(platform.name)
                                .font(.footnote)
                        }
                    }
                }
            }
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
        }
        .navigationBarTitle("Platforms", displayMode: .inline)
        .scrollIndicators(.hidden)
    }

    private func filteredPlatforms(for id: String) -> [GamePlatformModel] {
        viewModel.platforms.filter { $0.name.hasPrefix(id) }
    }
}

// MARK: - Platform Games View

struct PlatformGamesView: View {
    var platform: GamePlatformModel
    @State private var games: [GameModel] = []
    @State private var currentOffset = 0
    @State private var isLoading = false
    @State private var areGamesAvailable: Bool = true
    @EnvironmentObject var networkManager: NetworkManager

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]

    var body: some View {
        ScrollViewReader { _ in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(gameID: game.id)) {
                            GameThumbnailCell(url: game.coverURL, name: game.name)
                        }
                    }
                }
                .padding()

                if networkManager.isConnected {
                    if isLoading && areGamesAvailable {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                            .scaleEffect(2.0)
                    } else if areGamesAvailable {
                        Text("Load More")
                            .onAppear {
                                loadMoreContent()
                            }
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("No connection found.\nConnect to the internet to load games.")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                }
            }
            .navigationBarTitle(platform.name, displayMode: .inline)
            .onAppear {
                if games.isEmpty {
                    fetchGames(offset: currentOffset)
                }
            }
        }
    }

    private func loadMoreContent() {
        if !isLoading {
            isLoading = true
            currentOffset += 30
            fetchGames(offset: currentOffset)
        }
    }

    private func fetchGames(offset: Int) {
        APIManager.shared.getGamesByPlatform(for: platform, currentOffset: offset) { result in
            isLoading = false
            switch result {
            case let .success(popularGames):
                if popularGames.isEmpty {
                    areGamesAvailable = false
                } else {
                    games.append(contentsOf: popularGames)
                }
            case let .failure(error):
                print("Failed to get popular games: \(error)")
            }
        }
    }
}

struct PlatformsView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformsView()
    }
}
