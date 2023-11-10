//
//  HomeView.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import IGDB_SWIFT_API
import SwiftUI

struct HomeView: View {
    @State private var selectedCategory: GameCategory = .popular

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(PlatformModel.allCases, id: \.self) { platform in
                        let gamesList = GameList(platform: platform, category: selectedCategory)
                        GameListView(gamesList: gamesList)
                    }
                }
            }
            .navigationBarTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        ForEach(GameCategory.allCases, id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                            }) {
                                Text(category.rawValue)
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
