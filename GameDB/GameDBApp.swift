//
//  GameDBApp.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import SwiftUI
import TipKit

@main
struct GameDBApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = false
    @StateObject var networkManager = NetworkManager()

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
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .onAppear {
                setupTips()
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
