//
//  DeepLinkRouter.swift
//  GameDB
//
//  Routes widget deep links to the matching screen.
//

import SwiftUI

enum AppTab: Hashable {
    case home
    case news
    case search
    case summary
    case settings
}

@MainActor
final class DeepLinkRouter: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published var summaryPath: [SaveGamesCategory] = []

    func handle(_ url: URL) {
        guard url.scheme == WidgetConstants.urlScheme else { return }

        // Supports gamedb://upcoming
        switch url.host {
        case WidgetConstants.upcomingHost:
            showUpcomingGames()
        default:
            break
        }
    }

    func showUpcomingGames() {
        selectedTab = .summary
        summaryPath = [.upcoming]
    }
}
