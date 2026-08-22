//
//  GameDBApp.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import SwiftUI
import TipKit
import WidgetKit

@main
struct GameDBApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @StateObject var networkManager = NetworkManager()
    @StateObject private var deepLinkRouter = DeepLinkRouter()

    init() {
        WidgetCenter.shared.reloadTimelines(ofKind: WidgetConstants.upcomingGamesKind)
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboardingComplete {
                    ContentView()
                } else {
                    OnboardingView(isOnboardingComplete: $isOnboardingComplete)
                }
            }
            .environment(\.managedObjectContext, GameDataProvider.shared.viewContext)
            .environmentObject(networkManager)
            .environmentObject(deepLinkRouter)
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .onAppear {
                setupTips()
            }
            .onOpenURL { url in
                deepLinkRouter.handle(url)
            }
        }
    }

    private func setupTips() {
        Task {
            do {
                try Tips.configure([
                    .displayFrequency(.immediate),
                    .datastoreLocation(.applicationDefault),
                ])
            } catch {
                print("Error configuring tips: \(error)")
            }
        }
    }
}
