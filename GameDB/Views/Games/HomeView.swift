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
                    VStack(alignment: .leading) {
                        //                        Text(platformName.description)
                        //                            .font(.headline)
                        //                            .padding(.leading, 15)
                        //                            .padding(.top, 5)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            LazyHStack(spacing: 15) {
                                ForEach(gameList.games) { game in
                                    NavigationLink(destination: GameDetailView(gameID: game.id)) {
                                        GameThumbnail(game: game)
                                            .frame(width: 155)
                                    }
                                }
                            }
                            .padding(.horizontal, 15)
                        }
                    }
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
