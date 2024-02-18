//
//  ContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 7/15/22.
//

import SwiftUI

struct ContentView: View {
    
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
            
            
            SummaryView()
                .tabItem {
                    VStack {
                        Image(systemName: "chart.pie.fill")
                        Text("Summary")
                    }
                }
                .tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
