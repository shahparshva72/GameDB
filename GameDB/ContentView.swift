//
//  ContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/15/22.
//

import SwiftUI

struct ContentView: View {
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
        // Custom font for tab bar
        UITabBarItem.appearance().setTitleTextAttributes([
            NSAttributedString.Key.font: UIFont(name: "PressStart2P-Regular", size: 10)!,
        ], for: .normal)
        
        // Custom font for navigation bar
        
        let appear = UINavigationBarAppearance()
        
        let atters: [NSAttributedString.Key: Any] = [
            .font: UIFont(name: "PressStart2P-Regular", size: 12)!
        ]
        
        appear.largeTitleTextAttributes = atters
        appear.titleTextAttributes = atters
        UINavigationBar.appearance().standardAppearance = appear
        UINavigationBar.appearance().compactAppearance = appear
//        UINavigationBar.appearance().scrollEdgeAppearance = appear
        
    }
    
    @EnvironmentObject private var deepLinkRouter: DeepLinkRouter

    var body: some View {
        TabView(selection: $deepLinkRouter.selectedTab) {
            Tab("Home", systemImage: "gamecontroller", value: AppTab.home) {
                HomeView()
            }

            if FeatureFlags.newsEnabled {
                Tab("News", systemImage: "newspaper.fill", value: AppTab.news) {
                    NewsFeedView()
                }
            }

            Tab("Search", systemImage: "magnifyingglass", value: AppTab.search) {
                SearchView()
            }

            Tab("Summary", systemImage: "chart.pie.fill", value: AppTab.summary) {
                SummaryView()
            }

            Tab("Settings", systemImage: "gearshape.fill", value: AppTab.settings) {
                SettingsView()
            }
        }
        .tint(.accentColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(DeepLinkRouter())
    }
}
