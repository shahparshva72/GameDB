//
//  SummaryView.swift
//  GameDB
//
//  Created by Parshva Shah on 10/3/23.
//

import SwiftUI

struct BoxItem {
    var symbolName: String
    var title: String
    var category: SaveGamesCategory
}

struct SummaryView: View {
    @ObservedObject var summaryVM = SummaryViewModel()
    @ObservedObject var savedGamesVM = SavedGamesViewModel(category: .upcoming)
    
    let layout: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 10), count: 2)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: layout, spacing: 10) {
                    ForEach(summaryVM.gameCounts.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key.rawValue) { category, count in
                        let item = boxItem(for: category)
                        NavigationLink(destination: destinationView(for: category)) {
                            BoxView(symbolName: item.symbolName, title: item.title, count: count, categoryColor: category.color)
                        }
                    }
                }
                
                Spacer()
                
                VStack(alignment: .leading) {
                    Text("Upcoming Games")
                        .font(.title3.bold())
                    
                    ForEach(savedGamesVM.savedGames) { game in
                        GameCountdownView(game: game)
                    }
                }
            }
            .padding()
            .navigationTitle("Summary")
            .onAppear {
                summaryVM.fetchAllCounts()
            }
        }
    }
    
    func boxItem(for category: SaveGamesCategory) -> BoxItem {
        switch category {
        case .played:
            return BoxItem(symbolName: "triangle", title: "Games Played", category: .played) // PlayStation's triangle button
        case .toPlay:
            return BoxItem(symbolName: "circle", title: "Games to Play", category: .toPlay) // PlayStation's circle button
        case .upcoming:
            return BoxItem(symbolName: "xmark", title: "Upcoming Games", category: .upcoming) // Represents PlayStation's cross button; there's no exact match in SF Symbols
        case .favorite:
            return BoxItem(symbolName: "square", title: "Favorites", category: .favorite) // PlayStation's square button
        case .playing:
            return BoxItem(symbolName: "dpad", title: "Currently Playing", category: .playing)
        }
    }
    
    
    func destinationView(for category: SaveGamesCategory) -> some View {
        let viewModel = SavedGamesViewModel(category: category)
        switch category {
        case .played, .toPlay, .upcoming, .favorite, .playing:
            return SavedGamesView(viewModel: viewModel)
        }
    }
}


struct SavedGamesView: View {
    @ObservedObject var viewModel: SavedGamesViewModel
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        Group {
            if viewModel.savedGames.isEmpty {
                VStack {
                    Spacer()
                    Text("No games added yet.")
                        .foregroundColor(.secondary)
                        .font(.headline)
                    Text("Please add a game using \(Image(systemName: "plus.app")) to see it here.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                        .padding(.top, 2)
                    Spacer()
                }
            } else {
                ScrollView {
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        LazyVGrid(columns: columns, spacing: 20) {
                            ForEach(viewModel.savedGames, id: \.id) { game in
                                NavigationLink(destination: GameDetailView(gameID: game.id)) {
                                    if let url = URL(string: game.coverURLString) {
                                        GameThumbnail(url: url, name: game.name)
                                            .aspectRatio(1, contentMode: .fit)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationTitle(viewModel.category.description)
    }
}


#Preview {
    SummaryView()
}
