//
//  FeedSelectionView.swift
//  GameDB
//
//  Created by Parshva Shah on 10/29/23.
//

import SwiftUI

class FeedSelectionViewModel: ObservableObject {
    @Published var feedNames: [String] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    func fetchFeedNames() async {
        DispatchQueue.main.async {
            self.isLoading = true
            self.errorMessage = nil
        }

        do {
            let fetchedNames = try await NewsAPIManager.shared.fetchFeedNames()
            DispatchQueue.main.async {
                self.feedNames = fetchedNames
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch feed names."
                self.isLoading = false
            }
        }
    }
}

struct FeedSelectionView: View {
    @StateObject var viewModel = FeedSelectionViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = true

    // Colors for Light and Dark modes
    private var textColor: Color {
        isDarkMode ? .cyan : .green
    }

    private var loadingTextColor: Color {
        isDarkMode ? .yellow : .blue
    }

    private var errorColor: Color {
        isDarkMode ? .red : .purple
    }

    private var backgroundColor: Color {
        isDarkMode ? .black : .white
    }

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .foregroundColor(loadingTextColor)
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(errorColor)
            } else {
                List(viewModel.feedNames, id: \.self) { name in
                    Text(name)
                        .foregroundColor(textColor)
                        .padding(.vertical, 5)
                }
            }
        }
        .pixelatedFont(size: 12)
        .navigationTitle("List of Feeds")
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
        .onAppear {
            Task {
                await viewModel.fetchFeedNames()
            }
        }
    }
}

#Preview {
    FeedSelectionView()
}
