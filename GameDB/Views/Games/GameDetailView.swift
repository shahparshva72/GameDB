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
    @State private var isSaved: Bool = false
    
    private let standardPadding: CGFloat = 20
    @State private var showSpoilerWarning = false
    @State private var showStorylineWarning = false
    
    var body: some View {
        Group {
            if let game = viewModel.game {
                GameDetailContent(game: game, showSpoilerWarning: $showSpoilerWarning, showStorylineWarning: $showStorylineWarning)
                    .padding([.horizontal], standardPadding)
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

struct GameDetailContent: View {
    var game: GameModel
    @Binding var showSpoilerWarning: Bool
    @Binding var showStorylineWarning: Bool
    @State private var isSaved: Bool = false  // Introduce this to track saved state
    
    var body: some View {
        ScrollView {
            VStack {
                CoverImageView(url: game.coverURL, isSaved: $isSaved, toggleSaved: toggleSaved)
                GameInformationView(game: game, showSpoilerWarning: $showSpoilerWarning, showStorylineWarning: $showStorylineWarning)
            }
            Spacer()
        }
    }
    
    // Function to toggle the saved state
    func toggleSaved() {
        isSaved.toggle()
        // Here you can also add logic to save this state somewhere if needed, e.g., UserDefaults, CoreData, etc.
    }
}


struct CoverImageView: View {
    var url: URL?
    @Binding var isSaved: Bool
    var toggleSaved: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: url) { phase in
                switch phase {
                case .success(let image):
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

            Button(action: toggleSaved) {
                Image(systemName: isSaved ? "star.fill" : "star")
                    .resizable()
                    .foregroundColor(isSaved ? .yellow : .gray)
                    .frame(width: 24, height: 24)
                    .padding(.all, 16)
            }
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
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.secondary)
                    Text("By: \(game.company)")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.secondary)
                    Text("Release date: \(game.releaseDateText)")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(game.genreText)
                        .fontWeight(.medium)
                }
                
                HStack {
                    Image(systemName: "star.circle.fill")
                        .foregroundColor(.orange)
                    Text("Rating: \(String(format: "%.1f", game.rating))")
                        .fontWeight(.medium)
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
                    // The actual summary, but it will be hidden when the spoiler warning is not shown
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
                    // The actual storyline, but it will be hidden when the spoiler warning is not shown
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


struct ScreenshotsViewWrapper: View {
    var urls: [URL]
    
    var body: some View {
        NavigationView {
            ScreenshotsSection(urls: urls)
        }
    }
}

struct ScreenshotsSection: View {
    var urls: [URL]
    
    var body: some View {
        VStack {
            Text("Screenshots").font(.headline).padding(.top)
            
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
    @State private var showFullScreenImage: Bool = false

    var body: some View {
        VStack {
            TabView(selection: $selectedPage) {
                ForEach(urls.indices, id: \.self) { index in
                    NavigationLink(destination: FullScreenImageView(url: urls[index])) {
                        ScreenshotImageView(url: urls[index])
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 200)
            
            // Custom page dots below the image carousel
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
            case .success(let image):
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

struct FullScreenImageView: View {
    var url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image.resizable().aspectRatio(contentMode: .fit)
                    .background(Color.black)
                    .edgesIgnoringSafeArea(.all)
            case .failure:
                Image(systemName: "photo").resizable().aspectRatio(contentMode: .fit).background(Color.black)
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


struct GameDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GameDetailView(gameID: 1009) // The Last of Us
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
