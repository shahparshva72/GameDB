//
//  PlatformsView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

// ref:-  https://stackoverflow.com/questions/65185161/swiftui-how-to-add-letters-sections-and-alphabet-jumper-in-a-form

import SwiftUI
import Combine

struct PlatformsView: View {
    @StateObject var viewModel = GamePlatformViewModel()
    
    private var sectionIdentifiers: [String] {
        Set(viewModel.platforms.map { String($0.name.prefix(1)) }).sorted()
    }
    
    var body: some View {
        ScrollViewReader { value in
            VStack {
                if viewModel.searchText.isEmpty {
                    List(sectionIdentifiers, id: \.self) { id in
                        Section {
                            ForEach(filteredPlatforms(for: id), id: \.id) { platform in
                                NavigationLink(destination: PlatformGamesView(platform: platform)) {
                                    Text(platform.name)
                                }
                            }
                        } header: {
                            Text(id)
                        }
                        .id(id)
                    }
                    .overlay(alignment: .trailing) {
                        QuickScroll(sectionIdentifiers: sectionIdentifiers, value: value) { item in
                            Text(item)
                        }
                    }
                } else {
                    List(viewModel.platforms, id: \.id) { platform in
                        NavigationLink(destination: PlatformGamesView(platform: platform)) {
                            Text(platform.name)
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
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        ScrollViewReader { scrollViewProxy in
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(games) { game in
                        NavigationLink(destination: GameDetailView(gameID: game.id)) {
                            GameThumbnail(url: game.coverURL, name: game.name)
                                .frame(width: 155)
                        }
                    }
                    
                    if isLoading && areGamesAvailable {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .scaleEffect(2.0)
                    } else if areGamesAvailable {
                        Text("Load More")
                            .onAppear {
                                loadMoreContent()
                            }
                    }
                }
                .padding()
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
            case .success(let popularGames):
                if popularGames.isEmpty {
                    areGamesAvailable = false
                } else {
                    games.append(contentsOf: popularGames)
                }
            case .failure(let error):
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
