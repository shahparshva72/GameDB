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
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, GameDataProvider.shared.viewContext)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
