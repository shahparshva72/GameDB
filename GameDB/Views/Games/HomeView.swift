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
    @State private var selectedCategory: GameCategory = .criticallyAcclaimed
    @State private var selectedPlatform: PlatformModel = .ps5
    @Namespace var namespace
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 8) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(PlatformModel.allCases, id: \.self) { platform in
                            Button(action: {
                                selectedPlatform = platform
                            }) {
                                VStack {
                                    Image(platform.assetName)
                                        .resizable()
                                        .renderingMode(.template)
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 44, height: 44)
                                        .padding(8)
                                        .foregroundColor(
                                            platform.assetColor
                                        )
                                        .clipShape(Circle())
                                    
                                    if selectedPlatform == platform {
                                        Rectangle()
                                            .frame(height: 2)
                                            .foregroundColor(
                                                platform == selectedPlatform ? platform.assetColor : .clear
                                            )
                                            .matchedGeometryEffect(id: "underline", in: namespace, properties: .frame, isSource: true)
                                    }
                                }
                                .animation(.linear(duration: 0.3), value: selectedPlatform)
                                .transition(.slide)
                            }
                        }
                    }
                }
                .padding(.vertical)

                ScrollView(.vertical) {
                    let gamesList = GameList(platform: selectedPlatform, category: selectedCategory)
                    GameListView(gamesList: gamesList)
                }
            }
            .padding(.horizontal, 15)
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
                        Text(selectedCategory.rawValue)
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
