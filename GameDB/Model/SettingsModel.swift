//
//  SettingsModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/13/23.
//

import SwiftUI

enum SettingsModel: String, Hashable, CaseIterable, Identifiable, View {
    case appearance = "Appearance"
    case feed = "Feed"
    case credits = "Credits"
    case about = "About"
    
    var id: String {
        self.rawValue
    }
    
    var body: some View {
        switch self {
        case .appearance:
            AppearanceView()
        case .feed:
            FeedView()
        case .credits:
            CreditsView()
        case .about:
            AboutView()
        }
    }
}
