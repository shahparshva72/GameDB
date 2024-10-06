//
//  GameDBApp.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import SwiftUI

@main
struct GameDBApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @StateObject var networkManager = NetworkManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, GameDataProvider.shared.viewContext)
                .environmentObject(networkManager)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
