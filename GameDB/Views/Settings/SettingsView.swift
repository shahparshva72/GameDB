//
//  SettingsView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

enum SettingsModel: String, CaseIterable {
    case appearance = "Appearance"
    case feed = "Feed"
    case credits = "Credits"
    case about = "About"
}

struct SettingsView: View {
    
    // TODO: - Add Appearances
    // TODO: - Add options for user to select RSS Feeds
    
    var body: some View {
        NavigationView {
            List(SettingsModel.allCases, id: \.self) { setting in
                NavigationLink(destination: SettingsDestinationView(setting: setting)) {
                    Text(setting.rawValue)
                }
            }
            .navigationBarTitle("Settings")
        }

    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
