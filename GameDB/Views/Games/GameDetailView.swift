//
//  GameDetailView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI
import Kingfisher
import AlertToast

struct GameDetailView: View {
    @StateObject private var viewModel = GameDetailViewModel()
    var gameID: Int
    @State private var showSpoilers: Bool = false
    
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertType: AlertToast.AlertType = .regular
    
    var body: some View {
        Group {
            if let game = viewModel.game {
                GameDetailContent(game: game, showSpoilers: $showSpoilers)
                    .background(ignoresSafeAreaEdges: .top)
            } else if viewModel.error != nil {
                VStack {
                    Text("Error fetching game")
                    Button {
                        viewModel.fetchGame(id: gameID)
                    } label: {
                        Text("Click to retry \(Image(systemName: "arrow.clockwise"))")
                    }
                    
                }
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchGame(id: gameID)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    withAnimation {
                        showSpoilers.toggle()
                    }
                } label: {
                    Image(systemName: showSpoilers ? "eye.slash" : "eye")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Section {
                        Text("Save to")
                        ForEach(SaveGamesCategory.allCases, id: \.self) { category in
                            Button(action: {
                                saveGame(inCategory: category)
                            }) {
                                HStack {
                                    Text(category.description)
                                    if isCategoryActive(category, for: gameID) {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                    }
                                }
                            }
                        }
                    }
                } label: {
                    Image(systemName: "plus.app")
                }
            }
        }
        .toast(isPresenting: $showAlert) {
            AlertToast(displayMode: .alert, type: alertType, title: alertTitle)
        }
    }
    
    func saveGame(inCategory category: SaveGamesCategory) {
        guard let game = viewModel.game else { return }
        
        if category == .upcoming && game.releaseDate <= Date() {
            alertTitle = "Cannot add game. Game already released"
            alertType = .error(.red)
            showAlert = true
        } else {
            GameDataProvider.shared.saveOrUpdateGame(
                id: game.id,
                name: game.name,
                releaseDate: game.releaseDate,
                coverURLString: game.coverURLString,
                category: category
            )
            
            if isCategoryActive(category, for: gameID) {
                alertTitle = "Game Added"
                alertType = .complete(.green)
                showAlert = true
            } else {
                alertTitle = "Game Removed"
                alertType = .complete(.green)
                showAlert = true
            }
        }
    }
    
    private func isCategoryActive(_ category: SaveGamesCategory, for gameID: Int) -> Bool {
        guard let gameDataModel = GameDataProvider.shared.fetchGameById(gameID) else { return false }
        
        switch category {
        case .played:
            return gameDataModel.isPlayed
        case .toPlay:
            return gameDataModel.isToPlay
        case .upcoming:
            return gameDataModel.isUpcoming
        case .favorite:
            return gameDataModel.isFavorite
        case .playing:
            return gameDataModel.isPlaying
        }
    }
}

struct GameDetailContent: View {
    var game: GameModel
    @Binding var showSpoilers: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ZStack {
                    CoverImageView(url: game.coverURL)
                        .blur(radius: 5)
                    
                    CoverImageView(url: game.coverURL)
                        .scaleEffect(0.95)
                        .frame(alignment: .center)
                        .animation(.easeInOut, value: true)
                }
                
                GameInformationView(game: game, showSpoilers: $showSpoilers)
                    .padding([.horizontal], 10)
            }
        }
    }
}

struct CoverImageView: View {
    var url: URL?
    
    var body: some View {
        KFImage(url)
            .placeholder {
                PlaceholderImage()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .overlay(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.2)]), startPoint: .center, endPoint: .bottom))
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
    }
}

struct GameInformationView: View {
    var game: GameModel
    @Binding var showSpoilers: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(game.name).font(.title2).padding(.top, 20)
            GameDetailsSection(game: game)
            SummarySection(summary: game.summary, showSpoilers: $showSpoilers)
            StorylineSection(storyline: game.storyline, showSpoilers: $showSpoilers)
            ScreenshotsSection(urls: game.screenshootURLs)
            VideosSection(videoIDs: game.videoIDs)
        }
    }
}

struct GameDetailsSection: View {
    var game: GameModel
    
    var body: some View {
        GroupBox(label: HStack {
            Image(systemName: "info.circle.fill")
                .foregroundColor(.blue)
            Text("Game Details")
                .font(.headline)
        }) {
            VStack(alignment: .leading, spacing: 8) {
                // Developed by
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    Text("By: \(game.company)")
                        .fontWeight(.medium)
                }
                
                // Release Date
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Release date: \(game.releaseDateText)")
                        .fontWeight(.medium)
                }
                
                // Rating
                HStack {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.orange)
                    Text("Rating: \(String(format: "%.1f", game.rating))")
                        .fontWeight(.medium)
                }
                
                // Critics Rating
                HStack {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.red)
                    Text("Critics Rating: \(String(format: "%.1f", game.aggregated_rating))")
                        .fontWeight(.medium)
                }
                
                // Genres
                HStack(spacing: 0) {
                    Image(systemName: "tag.fill")
                        .foregroundColor(.yellow)
                    
                    TagsGridView(tagNames: game.genres, tagColor: .green)
                        .padding(.horizontal)
                }
                
                // Platforms
                HStack(spacing: 0) {
                    Image(systemName: "gamecontroller")
                        .foregroundColor(.purple)
                    TagsGridView(tagNames: game.platforms, tagColor: .purple)
                        .padding(.horizontal)
                }
            }
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.vertical, 5)
        }
    }
}

struct SummarySection: View {
    var summary: String
    @Binding var showSpoilers: Bool
    
    var body: some View {
        GroupBox(label: Text("Summary")) {
            if summary.isEmpty {
                Text("No summary available.")
                    .foregroundColor(.secondary)
            } else {
                ZStack {
                    Text(summary)
                        .font(.body)
                        .lineLimit(nil)
                        .opacity(showSpoilers ? 1 : 0.02)
                    
                    // Tap to reveal spoilers
                    if !showSpoilers {
                        Text("Tap on \(Image(systemName: "eye")) to show spoilers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct StorylineSection: View {
    var storyline: String
    @Binding var showSpoilers: Bool
    
    var body: some View {
        GroupBox(label: Text("Storyline")) {
            if storyline.isEmpty {
                Text("No storyline available.")
                    .foregroundColor(.secondary)
            } else {
                ZStack {
                    Text(storyline)
                        .font(.body)
                        .lineLimit(nil)
                        .opacity(showSpoilers ? 1 : 0.02)
                    
                    // Tap to reveal spoilers
                    if !showSpoilers {
                        Text("Tap on \(Image(systemName: "eye")) to show spoilers")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

struct ScreenshotsSection: View {
    var urls: [URL]
    
    var body: some View {
        Section(header: Text("Screenshots")) {
            if urls.isEmpty {
                Text("No screenshots available.").foregroundColor(.secondary)
            } else {
                ScreenshotCarouselView(urls: urls)
            }
        }
    }
}

struct ScreenshotCarouselView: View {
    var urls: [URL]
    @State private var selectedPage: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(urls.indices, id: \.self) { index in
                    ScreenshotImageView(url: urls[index])
                        .padding(.horizontal, 8)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            
            // Custom dots
            HStack {
                ForEach(urls.indices, id: \.self) { index in
                    Circle()
                        .fill(selectedPage == index ? .accentColor : Color.gray)
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            withAnimation {
                                selectedPage = index
                            }
                        }
                }
            }
        }
    }
}

struct ScreenshotImageView: View {
    var url: URL
    
    var body: some View {
        KFImage(url)
            .placeholder {
                PlaceholderImage()
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(10)
    }
}


struct VideosSection: View {
    var videoIDs: [String]
    @State private var selectedVideoIndex: Int = 0
    
    var body: some View {
        Section(header: Text("Videos")) {
            if videoIDs.isEmpty {
                Text("No videos available.").foregroundColor(.secondary)
            } else {
                VStack(spacing: 16) {
                    TabView(selection: $selectedVideoIndex) {
                        ForEach(videoIDs.indices, id: \.self) { index in
                            VideoThumbnailButton(videoID: videoIDs[index])
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 200)
                    
                    HStack {
                        ForEach(videoIDs.indices, id: \.self) { index in
                            Circle()
                                .fill(selectedVideoIndex == index ? .accentColor : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                    }
                }
            }
        }
    }
}

struct VideoThumbnailButton: View {
    var videoID: String
    
    var body: some View {
        Button(action: {
            // Open the video in Safari
            if let url = URL(string: "https://www.youtube.com/watch?v=\(videoID)") {
                UIApplication.shared.open(url)
            }
        }) {
            KFImage.url(URL(string: "https://img.youtube.com/vi/\(videoID)/maxresdefault.jpg")!)
                .placeholder {
                    PlaceholderImage()
                }
                .resizable()
                .aspectRatio(contentMode: .fill)
                .cornerRadius(10)
                .overlay(
                    Image(systemName: "play.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.red)
                )
        }
    }
}

#Preview {
    GameDetailView(gameID: 1009) // The Last of Us
}
