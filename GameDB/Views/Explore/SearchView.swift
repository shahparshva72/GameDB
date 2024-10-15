//
//  SearchView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/6/23.
//

import AlertToast
import Combine
import IGDB_SWIFT_API
import Kingfisher
import SwiftUI

// MARK: - SearchView

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    @Environment(\.isSearching) private var isSearching

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.searchQuery.isEmpty && !isSearching {
                    ExploreView()
                } else {
                    searchResultsList
                }
            }
            .navigationTitle("Search")
            .searchable(text: $viewModel.searchQuery,
                        placement: .navigationBarDrawer(displayMode: .always),
                        prompt: Text("Search for games"))
            .onChange(of: viewModel.searchQuery) { oldValue, newValue in
                viewModel.fetchSearchResults(for: newValue)
            }
        }
    }

    private var searchResultsList: some View {
        List {
            switch viewModel.state {
            case .idle:
                EmptyView()
            case .loading:
                loadingView
            case let .loaded(results):
                ForEach(results) { game in
                    NavigationLink(destination: GameDetailView(gameID: game.id)) {
                        SearchCell(url: game.coverURL, name: game.name)
                    }
                }
            case let .error(message):
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

@MainActor
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
                case let .success(games):
                    self.state = .loaded(games)
                case let .failure(error):
                    self.state = .error(error.localizedDescription)
                }
            }
        }
    }
}

struct SearchCell: View {
    var url: URL?
    var name: String
    let thumbnailHeight: CGFloat = 50
    let thumbnailWidth: CGFloat = 50

    var body: some View {
        HStack(alignment: .center) {
            if let safeURL = url {
                KFImage.url(safeURL)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: thumbnailWidth, height: thumbnailHeight)
                    .clipped()
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            VStack(alignment: .leading, spacing: 10) {
                Text(name)
                    .font(.headline)
                    .padding(.horizontal, 5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .cornerRadius(10)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
