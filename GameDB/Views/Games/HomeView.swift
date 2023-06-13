//
//  ContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import SwiftUI
import IGDB_SWIFT_API

struct HomeView: View {
    
    @ObservedObject var gameList = GameList()
    @State var platformName: PlatformModel = .nswitch
    
    var body: some View {
        NavigationView {
            Group {
                if gameList.isLoading {
                    ProgressView()
                } else {
                    List(gameList.games) { game in
                        ZStack {
                            GameThumbnail(game: game)
                            NavigationLink(destination: GameDetailView(gameID: game.id)) {
                                EmptyView()
                            }
                            .opacity(0.0)
                        }
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle(Text(gameList.platformName))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(PlatformModel.allCases, id: \.self) { platform in
                            Button {
                                platformName = platform
                                self.gameList.reload(platform: platformName)
                            } label: {
                                Label(platform.description, image: platform.assetName)
                            }
                            
                        }
                    } label: {
                        Image(systemName: "list.bullet")
                    }
                }
            }
        }.onAppear {
            self.gameList.reload(platform: platformName)
        }
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
