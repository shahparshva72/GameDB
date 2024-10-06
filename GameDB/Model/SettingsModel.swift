//
//  SettingsModel.swift
//  GameDB
//
//  Created by Parshva Shah on 6/13/23.
//

import SwiftUI

enum SettingsModel: String, Hashable, CaseIterable, Identifiable, View {
    case packages = "Packages Used"
    case feed = "Feed"
    case about = "About"

    var id: String {
        rawValue
    }

    var body: some View {
        switch self {
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
        case .packages:
            return .green
        case .about:
            return .purple
        case .feed:
            return .orange
        }
    }
}
