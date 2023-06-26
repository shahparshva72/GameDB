//
//  PlatformsViewModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/18/23.
//

import SwiftUI

class PlatformsList: ObservableObject {
    @Published var platforms: [GamePlatformModel] = []
    
    let apiManager = APIManager.shared
    
    func fetchPlatform() {
        self.platforms = []
        
        apiManager.fetchPlatformDetails { [weak self] result in
            switch result {
            case .success(let platforms):
                self?.platforms = platforms
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

