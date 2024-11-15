//
//  SummaryView.swift
//  GameDB
//
//  Created by Parshva Shah on 10/3/23.
//

import SwiftUI
import TipKit

struct BoxItem {
    var symbolName: String
    var title: String
    var category: SaveGamesCategory
}

struct SummaryView: View {
    @ObservedObject var summaryVM = SummaryViewModel()
    @ObservedObject var savedGamesVM = SavedGamesViewModel(category: .upcoming)
    let upcomingGamesTip = UpcomingGamesWidgetTip()

    // Use flexible grid items with defined spacing
    let layout: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TipView(upcomingGamesTip)
                        .padding()

                    LazyVGrid(columns: layout, spacing: 20) {
                        ForEach(summaryVM.gameCounts.sorted(by: { $0.key.rawValue < $1.key.rawValue }), id: \.key.rawValue) { category, count in
                            let item = boxItem(for: category)
                            NavigationLink(destination: destinationView(for: category)) {
                                // Add padding around each BoxView to maintain spacing
                                BoxView(symbolName: item.symbolName, title: item.title, count: count, categoryColor: category.color)
                                    .padding(4) // Ensure there's some spacing between the grid items
                            }
                        }
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Summary")
                        .pixelatedFont(size: 20)
                }
            }
            .onAppear {
                summaryVM.fetchAllCounts()
            }
        }
    }
}

func boxItem(for category: SaveGamesCategory) -> BoxItem {
    switch category {
    case .played:
        return BoxItem(symbolName: "triangle", title: "Games Played", category: .played)
    case .toPlay:
        return BoxItem(symbolName: "circle", title: "Games to Play", category: .toPlay)
    case .upcoming:
        return BoxItem(symbolName: "xmark", title: "Upcoming Games", category: .upcoming)
    case .favorite:
        return BoxItem(symbolName: "square", title: "Favorites", category: .favorite)
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
                                    VStack(alignment: .leading) {
                                        if let url = URL(string: game.coverURLString) {
                                            GameThumbnailCell(url: url, name: game.name)
                                                .aspectRatio(1, contentMode: .fit)
                                        }

                                        if game.isUpcoming {
                                            var daysLeft: Int {
                                                Calendar.current.dateComponents([.day], from: Date(), to: game.releaseDate).day ?? 0
                                            }

                                            Text("\(daysLeft) days left")
                                                .font(.subheadline)
                                                .foregroundStyle(Color.white)
                                        }
                                    }
                                    .onAppear {
                                        if viewModel.category == .upcoming {
                                            checkDateStatus(for: viewModel.savedGames)
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(viewModel.category.description)
    }

    func checkDateStatus(for games: [GameDataModel]) {
        for game in games {
            GameDataProvider.shared.updateGameStatus(for: game)
        }
    }
}

#Preview {
    SummaryView()
}
