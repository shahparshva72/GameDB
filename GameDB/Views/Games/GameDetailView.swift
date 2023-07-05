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
                        AsyncImage(url: game.coverURL) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            default:
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack(alignment: .leading, spacing: standardPadding) {
                            Text(game.name)
                                .font(.title2)
                                .padding(.top, standardPadding)
                            
                            GroupBox(label: Text("Game Details")) {
                                Text("By: \(game.company)")
                                Text("Release date: \(game.releaseDateText)")
                                Text(game.genreText)
                                Text("Rating: \(String(format: "%.1f", game.rating))")
                            }
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            
                            GroupBox(label: Text("Summary")) {
                                Text(game.summary)
                                    .font(.body)
                                    .lineLimit(nil)
                            }
                            
                            GroupBox(label: Text("Storyline")) {
                                Text(game.storyline)
                                    .font(.body)
                                    .lineLimit(nil)
                            }
                            
                            Section(header: Text("Screenshots")) {
                                if game.screenshootURLs.isEmpty {
                                    Text("No screenshots available.")
                                        .foregroundColor(.secondary)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack(spacing: 10) {
                                            ForEach(game.screenshootURLs, id: \.self) { url in
                                                AsyncImage(url: url) { phase in
                                                    switch phase {
                                                    case .success(let image):
                                                        image
                                                            .resizable()
                                                            .aspectRatio(1.78, contentMode: .fit)
                                                    case .failure:
                                                        Image(systemName: "photo")
                                                            .resizable()
                                                            .aspectRatio(1.78, contentMode: .fit)
                                                    case .empty:
                                                        ProgressView()
                                                    @unknown default:
                                                        ProgressView()
                                                    }
                                                }
                                                .frame(height: 200)
                                                .cornerRadius(10)
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Section(header: Text("Videos")) {
                                if game.videoIDs.isEmpty {
                                    Text("No videos available.")
                                        .foregroundColor(.secondary)
                                } else {
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        LazyHStack {
                                            ForEach(game.videoIDs, id: \.self) { id in
                                                YoutubePlayerView(youtubeVideoID: id)
                                                    .frame(width: UIScreen.main.bounds.width - (2 * standardPadding), height: 200)
                                            }
                                        }
                                    }
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
