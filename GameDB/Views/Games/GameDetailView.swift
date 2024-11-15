//
//  GameDetailView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import AlertToast
import Kingfisher
import QuickLook
import SwiftUI
import TipKit

// MARK: - GameDetailView

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
        guard let game = viewModel.game else {
            alertTitle = "Error: Game data not available"
            alertType = .error(.red)
            showAlert = true
            return
        }

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

            if isCategoryActive(category, for: game.id) {
                alertTitle = "Game Added"
                alertType = .complete(.green)
                showAlert = true
            } else {
                alertTitle = "Game Removed"
                alertType = .complete(.blue)
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

// MARK: - GameDetailContent

struct GameDetailContent: View {
    var game: GameModel
    @Binding var showSpoilers: Bool

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10) {
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

// MARK: - CoverImageView

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

// MARK: - GameInformationView

struct GameInformationView: View {
    var game: GameModel
    @Binding var showSpoilers: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(game.name).font(.title2)
            TagsGridView(tagNames: game.genres, tagColor: .accentColor, tagType: .genre)
            TagsGridView(tagNames: game.platforms, tagColor: .accentColor, tagType: .platform)
            GameDetailsSection(game: game)
            SummarySection(summary: game.summary, showSpoilers: $showSpoilers)
            StorylineSection(storyline: game.storyline, showSpoilers: $showSpoilers)
            ScreenshotsSection(urls: game.screenshootURLs)
            VideosSection(videoIDs: game.videoIDs)
        }
    }
}

// MARK: - GameDetailsSection

struct GameDetailsSection: View {
    var game: GameModel

    var body: some View {
        GroupBox(label: Label("Game Detail", systemImage: "info.circle.fill")) {
            VStack(alignment: .leading, spacing: 10) {
                // Developed by
                Label("By \(game.company)", systemImage: "person.fill")

                // Release Date
                Label("Release date: \(game.releaseDateText)", systemImage: "calendar")

                // Rating
                Label("Rating: \(String(format: "%.1f", game.rating))", systemImage: "star.circle.fill")

                // Critics Rating
                Label("Critics Rating: \(String(format: "%.1f", game.aggregated_rating))", systemImage: "star.circle.fill")
            }
            .font(.subheadline)
            .padding(.vertical)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.secondary)
        }
    }
}

// MARK: - SummarySection

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

// MARK: - StorylineSection

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

// MARK: - ScreenshotsSection

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

// MARK: - ScreenshotCarouselView

struct ScreenshotCarouselView: View {
    var urls: [URL]
    @State private var selectedPage: Int = 0

    var body: some View {
        VStack(spacing: 16) {
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

// MARK: - ScreenshotImageView

struct ScreenshotImageView: View {
    var url: URL

    var body: some View {
        KFImage(url)
            .placeholder {
                PlaceholderImage()
            }
            .resizable()
            .aspectRatio(contentMode: .fill)
            .cornerRadius(10)
    }
}

// MARK: - VideosSection

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
                                .padding(.horizontal, 8)
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

// MARK: - VideoThumbnailButton

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
