//
//  HomeView.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

// TODO: - Add Network Connection error handling

import IGDB_SWIFT_API
import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: GameCategory = .CriticallyAcclaimed
    @State private var selectedPlatform: PlatformModel = .ps5
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PlatformModel.allCases, id: \.self) { platform in
                            Button(action: {
                                selectedPlatform = platform
                            }) {
                                Text(platform.description)
                                    .font(.headline)
                                    .fontWeight(.medium)
                                    .padding(8)
                                    .background(platform == selectedPlatform ? Color.accentColor.opacity(0.8) : Color.gray.opacity(0.3))
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                }

                
                ScrollView(.vertical) {
                    let gamesList = GameList(platform: selectedPlatform, category: selectedCategory)
                    GameListView(gamesList: gamesList)
                }
            }
            .padding(.leading, 15)
            .navigationBarTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(GameCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category == selectedCategory ? "✔️ \(category.rawValue)" : category.rawValue)
                            }
                        }
                    } label: {
                        Label("Choose Category", systemImage: "list.bullet")
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
