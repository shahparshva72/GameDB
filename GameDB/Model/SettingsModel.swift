//
//  SettingsModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/13/23.
//

import SwiftUI

enum SettingsModel: String, Hashable, CaseIterable, Identifiable, View {
//    case appearance = "Appearance"
    case packages = "Packages Used"
    case about = "About"
    case feed = "Feed"
    
    var id: String {
        self.rawValue
    }
    
    var body: some View {
        switch self {
//        case .appearance:
//            AppearanceView()
        case .packages:
            PackagesUsedView()
        case .about:
            AboutView()
        case .feed:
            FeedSelectionView()
        }
    }
    
    var icons: String {
        switch self {
//        case .appearance:
//            return "paintbrush"
        case .packages:
            return "cube.box"
        case .about:
            return "info.circle"
        case .feed:
            return "newspaper"
        }
    }
    
    var iconColor: Color {
        switch self {
//        case .appearance:
//            return .blue
        case .packages:
            return .green
        case .about:
            return .purple
        case .feed:
            return .orange
        }
    }
}
