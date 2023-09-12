//
//  ContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/15/22.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        // Setting the background color
        UITabBar.appearance().barTintColor = UIColor.systemBackground
        
        // Setting the selected item tint
        UITabBar.appearance().tintColor = UIColor.blue
        
        // Customizing unselected items
        let attributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12, weight: .bold),
            NSAttributedString.Key.foregroundColor: UIColor.gray
        ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
    }

    
    var body: some View {
        TabView {
            HomeView()
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
        }
        .font(.headline)  // Increase the font size for tab item texts.
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
