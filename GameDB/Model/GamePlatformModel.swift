//
//  GamePlatformModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/18/23.
//

import SwiftUI
import Combine

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
        guard let url = Bundle.main.url(forResource: "Platforms", withExtension: "json") else {
            print("Platforms.json file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            allPlatforms = try decoder.decode([GamePlatformModel].self, from: data)
            platforms = allPlatforms
        } catch {
            print("Error loading platforms: \(error)")
        }
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
