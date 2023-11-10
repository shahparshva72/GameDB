//
//  ContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/15/22.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        let appearance = UITabBar.appearance()
        appearance.standardAppearance.backgroundEffect = UIBlurEffect(style: .systemMaterialDark)
        appearance.tintColor = .blue

        appearance.standardAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .regular),
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
        ]

        appearance.standardAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10, weight: .semibold),
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]
    }


    
    var body: some View {
        TabView {
            ZStack {
                Color.red
                
                HomeView()
            }
                .tabItem {
                    VStack {
                        Image(systemName: "gamecontroller")
                            .imageScale(.large)
                        Text("Home")
                    }
                }
                .tag(0)
            
            NewsFeedView()
                .tabItem {
                    VStack {
                        Image(systemName: "newspaper.fill")
                            .imageScale(.large)
                        Text("News")
                    }
                }
                .tag(1)
            
            SearchView()
                .tabItem {
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .imageScale(.large)
                        Text("Search")
                    }
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    VStack {
                        Image(systemName: "gear")
                            .imageScale(.large)
                        Text("Settings")
                    }
                }
                .tag(3)
            SummaryView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.pie.fill")
                        Text("Summary")
                    }
                }
                .tag(4)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
