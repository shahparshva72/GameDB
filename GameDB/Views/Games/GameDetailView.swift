//
//  GameDetailView.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import SwiftUI

// TODO: - Implement Quicklook to show images in future.

struct GameDetailView: View {
    @StateObject private var viewModel = GameDetailViewModel()
    var gameID: Int
    
    @State private var showSpoilerWarning = false
    @State private var showStorylineWarning = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        Group {
            if let game = viewModel.game {
                GameDetailContent(game: game, showSpoilerWarning: $showSpoilerWarning, showStorylineWarning: $showStorylineWarning)
            } else if let error = viewModel.error {
                Text(error.localizedDescription)
            } else {
                ProgressView("Loading...")
            }
        }
        .onAppear {
            viewModel.fetchGame(id: gameID)
        }
        .toolbar {
            Menu {
                Section {
                    Text("Save to")
                    ForEach(SaveGamesCategory.allCases, id: \.self) { category in
                        Button(category.description) {
                            saveGame(inCategory: category)
                        }
                    }
                }
            } label: {
                Label("Save to", systemImage: "plus.app")
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    func saveGame(inCategory category: SaveGamesCategory) {
        guard let game = viewModel.game else { return }
        
        if category == .upcoming && game.releaseDate <= Date() {
            alertMessage = "Cannot save \(game.name) as upcoming games as release date has already passed"
            alertTitle = "Cannot add game"
            showAlert = true
        } else {
            GameDataProvider.shared.saveOrUpdateGame(
                id: game.id,
                name: game.name,
                releaseDate: game.releaseDate,
                coverURLString: game.coverURLString,
                category: category
            )
        }
    }
}

struct GameDetailContent: View {
    var game: GameModel
    @Binding var showSpoilerWarning: Bool
    @Binding var showStorylineWarning: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                CoverImageView(url: game.coverURL)
                GameInformationView(game: game, showSpoilerWarning: $showSpoilerWarning, showStorylineWarning: $showStorylineWarning)
                    .padding([.horizontal], 20)
            }
            Spacer()
        }
    }
}

struct CoverImageView: View {
    var url: URL?
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: url) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .overlay(LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.2)]), startPoint: .center, endPoint: .bottom))
                default:
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
            }
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .shadow(color: Color.black.opacity(0.25), radius: 10, x: 0, y: 10)
        }
    }
}

struct GameInformationView: View {
    var game: GameModel
    @Binding var showSpoilerWarning: Bool
    @Binding var showStorylineWarning: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(game.name).font(.title2).padding(.top, 20)
            GameDetailsSection(game: game)
            SummarySection(summary: game.summary, showSpoilerWarning: $showSpoilerWarning)
            StorylineSection(storyline: game.storyline, showStorylineSpoiler: $showStorylineWarning)
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
                
                // Genres
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    
                    TagsGridView(tagNames: game.genres, tagColor: .green)
                        .padding()
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
                    Text(" Critics Rating: \(String(format: "%.1f", game.aggregated_rating))")
                        .fontWeight(.medium)
                }
                
                // Platforms
                HStack {
                    Image(systemName: "gamecontroller")
                        .foregroundColor(.purple)
                    TagsGridView(tagNames: game.platforms, tagColor: .purple)
                        .padding()
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
    @Binding var showSpoilerWarning: Bool
    
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
                        .opacity(showSpoilerWarning ? 1 : 0.02)
                    
                    // Tap to reveal message
                    if !showSpoilerWarning {
                        Text("Tap to reveal summary")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                withAnimation {
                                    showSpoilerWarning = true
                                }
                            }
                    }
                }
            }
        }
    }
}

struct StorylineSection: View {
    var storyline: String
    @Binding var showStorylineSpoiler: Bool
    
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
                        .opacity(showStorylineSpoiler ? 1 : 0.02)
                    
                    // Tap to reveal message
                    if !showStorylineSpoiler {
                        Text("Tap to reveal storyline")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .onTapGesture {
                                withAnimation {
                                    showStorylineSpoiler = true
                                }
                            }
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
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            
            HStack {
                Spacer()
                ForEach(urls.indices, id: \.self) { index in
                    Circle()
                        .fill(selectedPage == index ? Color.blue : Color.gray)
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            withAnimation {
                                selectedPage = index
                            }
                        }
                }
                Spacer()
            }
        }
    }
}

struct ScreenshotImageView: View {
    var url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case let .success(image):
                image.resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
            case .failure:
                Image(systemName: "photo").resizable().aspectRatio(contentMode: .fit)
            case .empty:
                ProgressView()
            @unknown default:
                ProgressView()
            }
        }
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
                            YoutubePlayerView(youtubeVideoID: videoIDs[index])
                                .frame(width: UIScreen.main.bounds.width - (2 * 20), height: 200)
                                .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                    .frame(height: 220)
                    
                    // Custom page dots below the video player
                    HStack {
                        Spacer()
                        ForEach(videoIDs.indices, id: \.self) { index in
                            Circle()
                                .fill(selectedVideoIndex == index ? Color.blue : Color.gray)
                                .frame(width: 8, height: 8)
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}

#Preview {
    GameDetailView(gameID: 1009) // The Last of Us
}
