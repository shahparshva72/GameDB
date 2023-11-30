//
//  SettingsView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct SettingsView: View {
    
    // TODO: - Complete Settings View
    
    var body: some View {
        NavigationStack {
            List(SettingsModel.allCases, id: \.self) { setting in
                NavigationLink(setting.rawValue, value: setting)
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
