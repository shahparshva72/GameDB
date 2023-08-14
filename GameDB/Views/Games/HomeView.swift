//
//  ContentView.swift
//  GameDB
//
//  Created by Parshva Shah on 4/26/22.
//

import SwiftUI
import IGDB_SWIFT_API

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ForEach(PlatformModel.allCases, id: \.self) { platform in
                        GameListView(platform: platform)
                    }
                }
            }
            .navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
