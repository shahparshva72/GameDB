//
//  PlatformModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/22.
//

import Foundation

enum PlatformModel: Int, CaseIterable {
    case ps4 = 48
    case xboxone = 49
    case nswitch = 130
    case ps5 = 167
    case xboxSeries = 169
    case playStation2 = 8
    case nintendo64 = 4
    case wiiU = 41
    case playStation3 = 9
    case segaSaturn = 32
    case superNintendo = 19
    case wii = 5
    case xbox = 11
    case playStation = 7
    case xbox360 = 12
    case segaMegaDriveGenesis = 29
    case atari2600 = 59
    
    var description: String {
        switch self {
        case .ps4:
            return "PS4"
        case .xboxone:
            return "Xbox One"
        case .nswitch:
            return "Nintendo Switch"
        case .ps5:
            return "PS5"
        case .xboxSeries:
            return "Xbox Series"
        case .playStation2:
            return "PlayStation 2"
        case .nintendo64:
            return "Nintendo 64"
        case .wiiU:
            return "Wii U"
        case .playStation3:
            return "PlayStation 3"
        case .segaSaturn:
            return "Sega Saturn"
        case .superNintendo:
            return "Super Nintendo"
        case .wii:
            return "Wii"
        case .xbox:
            return "Xbox"
        case .playStation:
            return "PlayStation"
        case .xbox360:
            return "Xbox 360"
        case .segaMegaDriveGenesis:
            return "Sega Mega Drive/Genesis"
        case .atari2600:
            return "Atari 2600"
        }
    }
    
    func fetchGames(completion: @escaping (Result<[GameModel], Error>) -> Void) {
        APIManager.shared.getPopularGames(for: self) { result in
            switch result {
            case .success(let games):
                completion(.success(games))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
    }
}
