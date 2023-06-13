//
//  GameDetailView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI

struct GameDetailView: View {
    @StateObject private var viewModel = GameDetailViewModel()
    var gameID: Int
    
    private let standardPadding: CGFloat = 20
    
    var body: some View {
        Group {
            if let game = viewModel.game {
                ScrollView {
                    VStack {
                        AsyncImage(url: game.coverURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            Image(systemName: "gamecontroller")
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: standardPadding) {
                            Text(game.name)
                                .font(.title2)
                                .padding(.top, standardPadding)
                            
                            Section {
                                Text("By: \(game.company)")
                                Text("Release date: \(game.releaseDateText)")
                                Text(game.genreText)
                                Text("Rating: \(String(format: "%.1f", game.rating))")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                            Text(game.summary)
                                .font(.body)
                                .lineLimit(nil)
                            
                            Text(game.storyline)
                                .font(.body)
                                .lineLimit(nil)
                            
                            Section {
                                ScrollView {
                                    ForEach(game.screenshootURLs, id: \.self) { url in
                                        AsyncImage(url: url) { image in
                                            image
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                    }
                                }
                            }
                            
                            Section {
                                ForEach(game.videoIDs, id: \.self) { id in
                                    YoutubePlayerView(youtubeVideoID: id)
                                        .frame(width: UIScreen.main.bounds.width - (2 * standardPadding), height: 200)
                                }
                            }
                        }
                        .padding(standardPadding)
                    }
                    Spacer()
                }
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchGame(id: gameID)
        }
    }
}


struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView(gameID: 204350) // The Last of Us
    }
}
