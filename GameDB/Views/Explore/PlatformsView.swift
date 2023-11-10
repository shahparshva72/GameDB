//
//  PlatformsView.swift
//  GameDB
//
//  Created by Parshva Shah on 8/15/23.
//

import SwiftUI

struct PlatformsView: View {
    @ObservedObject var viewModel = GamePlatformViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.platforms) { platform in
                    NavigationLink(destination: PopularGamesView(platform: platform)) {
                        Text(platform.name)
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.draculaPurple)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitle("Platforms", displayMode: .inline) // Add a navigation bar title
    }
}



struct PopularGamesView: View {
    var platform: GamePlatformModel
    @State private var games: [GameModel] = []
    
    var body: some View {
        VStack {
            ForEach(games) { game in
                NavigationLink(destination: GameDetailView(gameID: game.id)) {
                    GameThumbnail(url: game.coverURL, name: game.name)
                        .frame(width: 155)
                }
            }
        }
        .onAppear {
            APIManager.shared.getPopularGames(for: platform) { result in
                switch result {
                case .success(let popularGames):
                    games = popularGames
                case .failure(let error):
                    print("Failed to get popular games: \(error)")
                }
            }
        }
    }
}


struct PlatformsView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformsView()
    }
}
