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
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else {
                List(viewModel.feedNames, id: \.self) { name in
                    Text(name)
                }
            }
        }
        .navigationTitle("List of Feeds")
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
