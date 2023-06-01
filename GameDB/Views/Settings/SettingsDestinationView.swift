//
//  SettingsDestinationView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct SettingsDestinationView: View {
    let setting: SettingsModel
    
    var body: some View {
        VStack{
            switch setting {
            case .appearance:
                AppearanceView()
            case .feed:
                FeedView()
            case .credits:
                CreditsView()
            case .about:
                AboutView()
            }
        }
        .navigationTitle(setting.rawValue)
    }
}
