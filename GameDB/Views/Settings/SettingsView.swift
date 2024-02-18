//
//  SettingsView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List(SettingsModel.allCases, id: \.self) { setting in
                NavigationLink(destination: setting) {
                    HStack {
                        Image(systemName: setting.icons)
                            .foregroundColor(setting.iconColor)
                        Text(setting.rawValue)
                    }
                    .font(.headline)
                }
            }
            .buttonStyle(.bordered)
            .navigationDestination(for: SettingsModel.self) { $0 }
            .navigationBarTitle("Settings")
        }
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
