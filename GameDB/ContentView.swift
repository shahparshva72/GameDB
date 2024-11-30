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
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "gamecontroller")
                }
                .tag(0)
            
            NewsFeedView()
                .tabItem {
                    Label("News", systemImage: "newspaper.fill")
                }
                .tag(1)
            
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(2)
            
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "chart.pie.fill")
                }
                .tag(3)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
                .tag(4)
        }
        .tint(.accentColor)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
