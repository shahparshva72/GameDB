//
//  SearchView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/6/23.
//

import SwiftUI
import IGDB_SWIFT_API
import Combine

// MARK: - SearchView
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if viewModel.searchQuery.isEmpty {
                    ExploreView()
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: Text("Search for games"))
            .onChange(of: viewModel.searchQuery, perform: viewModel.fetchSearchResults)
        }
    }
    
    private var searchResultsList: some View {
        List {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                loadingView
            case .loaded(let results):
                ForEach(results) { game in
                    NavigationLink(destination: GameDetailView(gameID: game.id)) {
                        GameThumbnailCell(url: game.coverURL, name: game.name)
                    }
                }
            case .error(let message):
                Text(message)
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private var loadingView: some View {
        HStack {
            Spacer()
            ProgressView()
            Spacer()
        }
    }
}

// MARK: - SearchViewModel
class SearchViewModel: ObservableObject {
    enum State {
        case idle
        case loading
        case loaded([GameModel])
        case error(String)
    }

    @Published var searchQuery: String = ""
    @Published private(set) var state: State = .idle
    
    private var manager = APIManager.shared
    private var cancellables: Set<AnyCancellable> = []

    func fetchSearchResults(for query: String) {
        guard !query.isEmpty else {
            state = .idle
            return
        }
        
        state = .loading
        manager.searchGames(for: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let games):
                    self.state = .loaded(games)
                case .failure(let error):
                    self.state = .error(error.localizedDescription)
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
