//
//  GamePlatformModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/18/23.
//

import SwiftUI

struct GamePlatformModel: Identifiable, Decodable {
    let id: Int
    var name: String
}

class GamePlatformViewModel: ObservableObject {
    @Published var platforms: [GamePlatformModel] = []

    init() {
        loadPlatforms()
    }

    func loadPlatforms() {
        guard let url = Bundle.main.url(forResource: "Platforms", withExtension: "json") else {
            print("Platforms.json file not found")
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            platforms = try decoder.decode([GamePlatformModel].self, from: data)
        } catch {
            print("Error loading platforms: \(error)")
        }
    }
}
