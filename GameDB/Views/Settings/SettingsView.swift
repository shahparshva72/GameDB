//
//  SettingsView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false

    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Appearance")) {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                    }
                    .font(.headline)
                }

                Section(header: Text("General Settings")) {
                    ForEach(SettingsModel.allCases, id: \.self) { setting in
                        NavigationLink(destination: setting) {
                            Label(setting.rawValue, systemImage: setting.icons)
                        }
                        .font(.headline)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationBarTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
