//
//  GamePlatformModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/18/23.
//

import Combine
import SwiftUI

struct GamePlatformModel: Identifiable, Decodable {
    let id: Int
    var name: String
}

class GamePlatformViewModel: ObservableObject {
    @Published var platforms: [GamePlatformModel] = []
    @Published var searchText = ""
    private var allPlatforms: [GamePlatformModel] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadPlatforms()
        setupSearch()
    }

    private func loadPlatforms() {
        guard let url = URL(string: "https://gist.githubusercontent.com/shahparshva72/17b5703e77be6f0db890a0b7d49e340f/raw/ffb3131fcb7e126bf4d276aa576906211b5283f9/platforms.json") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [GamePlatformModel].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case let .failure(error) = completion {
                        print("Error loading platforms: \(error.localizedDescription)")
                    }
                },
                receiveValue: { [weak self] platforms in
                    self?.allPlatforms = platforms
                    self?.platforms = platforms
                }
            )
            .store(in: &cancellables)
    }

    private func setupSearch() {
        $searchText
            .removeDuplicates()
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .map { searchText in
                searchText.isEmpty ? self.allPlatforms : self.allPlatforms.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
            }
            .assign(to: \.platforms, on: self)
            .store(in: &cancellables)
    }
}
