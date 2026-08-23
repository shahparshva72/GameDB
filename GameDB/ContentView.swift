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
