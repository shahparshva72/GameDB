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
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(game.name)
                                .font(.title2)
                                .padding(.top, 10)
                            
                            Text("By: \(game.company)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Release date: \(game.releaseDateText)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text(game.genreText)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            Text("Rating: \(String(format: "%.1f", game.rating))")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.bottom, 10)
                            
                            Text(game.summary)
                                .font(.body)
                                .lineLimit(nil)
                            
                            Text(game.storyline)
                                .font(.body)
                                .lineLimit(nil)
                            
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
                        .padding(.horizontal, 20)
                    }
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
