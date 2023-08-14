//
//  SearchView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/6/23.
//

import SwiftUI
import IGDB_SWIFT_API
import Combine

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    public init() {}
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.searchQuery.isEmpty {
                    ExploreView()
                } else {
                    List {
                        makeSearchResultsView()
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: Text("Search for games"))
        }
    }
    
    @ViewBuilder
    private func makeSearchResultsView() -> some View {
        if let results = viewModel.results {
            if results.isEmpty && !viewModel.isLoading {
                EmptyStateView(iconName: "magnifyingglass",
                               title: "No Results",
                               message: "No games found for \(viewModel.searchQuery)")
                .listRowSeparator(.hidden)
            } else {
                ForEach(results, id: \.id) { game in
                    NavigationLink(destination: GameDetailView(gameID: game.id)) {
                        Text(game.name)
                    }
                }
            }
        } else if viewModel.isLoading {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
            .listRowSeparator(.hidden)
        } else if let errorMessage = viewModel.errorMessage {
            Text(errorMessage)
                .listRowSeparator(.hidden)
        }
    }
}

struct EmptyStateView: View {
    var iconName: String
    var title: String
    var message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
        }
        .padding()
    }
}


class SearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var results: [GameModel]?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    var manager = APIManager.shared
    
    init() {
        $searchQuery
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { query in
                self.fetchSearchResults(for: query)
            }
            .store(in: &cancellables)
    }
    
    private var cancellables: Set<AnyCancellable> = []
    
    private func fetchSearchResults(for query: String) {
        if query.isEmpty {
            results = []
            return
        }
        
        isLoading = true
        errorMessage = nil
        manager.searchGames(for: query) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let games):
                    self.results = games
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
}



struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
