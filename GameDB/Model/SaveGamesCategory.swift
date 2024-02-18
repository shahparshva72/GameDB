//
//  TrackCategory.swift
//  GameDB
//
//  Created by Parshva Shah on 10/9/23.
//

import SwiftUI

enum SaveGamesCategory: String, CaseIterable {
    case played = "Games Played"
    case toPlay = "Games to Play"
    case upcoming = "Upcoming Games"
    case favorite = "Favorite Games"
    case playing = "Currently Playing"
    
    var description: String {
        return self.rawValue
    }
    
    var color: Color {
        switch self {
        case .played:
            // Cadmium Red
            return Color(red: 223 / 255.0, green: 0 / 255.0, blue: 36 / 255.0)
        case .toPlay:
            // Golden Poppy
            return Color(red: 243 / 255.0, green: 195 / 255.0, blue: 0 / 255.0)
        case .upcoming:
            // Persian Green
            return Color(red: 0 / 255.0, green: 172 / 255.0, blue: 159 / 255.0)
        case .favorite:
            // Celtic Blue
            return Color(red: 46 / 255.0, green: 109 / 255.0, blue: 180 / 255.0)
        case .playing:
            // Dracula Purple
            return Color(red: 189 / 255, green: 147 / 255, blue: 249 / 255)
        }
    }
}
