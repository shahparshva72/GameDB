//
//  PlatformsList.swift
//  GameDB
//
//  Created by Parshva Shah on 6/18/23.
//
//
//import SwiftUI
//
//class PlatformsList: ObservableObject {
//    @Published var platforms: [GamePlatformModel] = []
//
//    let apiManager = APIManager.shared
//
//    func fetchPlatform() {
//        platforms = []
//
//        apiManager.fetchPlatformDetails { [weak self] result in
//            guard let self = self else { return }
//
//            switch result {
//            case let .success(platforms):
//                self.platforms = platforms
//            case let .failure(error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//}
