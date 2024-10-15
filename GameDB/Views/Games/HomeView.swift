//
//  HomeView.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import IGDB_SWIFT_API
import SwiftUI

struct HomeView: View {
    @ObservedObject var networkManager = NetworkManager()
    @StateObject private var gameList = GameList(platform: .ps5, category: .criticallyAcclaimed)
    @Namespace var namespace
    @State private var isInitialLoad = true

    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PlatformModel.allCases, id: \.self) { platform in
                            Button(action: {
                                gameList.updatePlatform(platform)
                            }) {
                                VStack {
                                    Image(platform.assetName)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 44, height: 44)
                                        .padding(8)
                                        .foregroundColor(platform.assetColor)
                                        .clipShape(Circle())

                                    if gameList.platformDescription == platform.description {
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(platform == gameList.platform ? platform.assetColor : .clear)
                                            .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame, isSource: true)
                                    }
                                }
                                .animation(.linear(duration: 0.3), value: gameList.platformDescription)
                                .transition(.slide)
                            }
                        }
                    }
                }
                .padding(.vertical)

                if networkManager.isConnected {
                    ScrollView(.vertical) {
                        GameListView(gamesList: gameList)
                    }

                    .refreshable {
                        await gameList.refreshGames()
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
            .padding(.horizontal, 15)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Home")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .fontWidth(.standard)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        ForEach(GameCategory.allCases, id: \.self) { category in
                            Button(action: {
                                gameList.updateCategory(category)
                            }) {
                                Text(category.rawValue)
                            }
                        }
                    } label: {
                        Text(gameList.category.rawValue)
                    }
                }
            })
        }
        .onChange(of: networkManager.isConnected) { oldValue, newValue in
            if newValue && isInitialLoad {
                gameList.fetchGames()
                isInitialLoad = false
            }
        }
    }
}

extension GameList {
    func refreshGames() async {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.games.removeAll()
            self.fetchGames()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
