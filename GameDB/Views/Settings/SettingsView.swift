//
//  SettingsView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete = true
    
    // Colors for Light and Dark modes
    private var headerColor: Color {
        .primary
    }
    
    private var labelColor: Color {
        .primary
    }
    
    private var onboardingLabelColor: Color {
        .primary
    }
    
    private var backgroundColor: Color {
        isDarkMode ? .black : .white
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Appearance")
                    .pixelatedFont(size: 14, color: headerColor))
                {
                    Toggle(isOn: $isDarkMode) {
                        Label("Dark Mode", systemImage: isDarkMode ? "moon.fill" : "sun.max.fill")
                            .pixelatedFont(size: 12, color: labelColor)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: isDarkMode ? .purple : .orange))
                }
                
                Section(header: Text("General Settings").pixelatedFont(size: 14, color: headerColor)) {
                    ForEach(SettingsModel.visibleCases, id: \.self) { setting in
                        NavigationLink(destination: setting) {
                            Label(setting.rawValue, systemImage: setting.icons)
                                .pixelatedFont(size: 12, color: labelColor)
                        }
                    }
                    
                    Button {
                            isOnboardingComplete.toggle()
                    } label: {
                        Label("Show Onboarding", systemImage: "apps.iphone")
                            .pixelatedFont(size: 12, color: onboardingLabelColor)
                    }
                    .accessibilityHint("Shows the introduction again")
                }
            }
            .navigationTitle("Settings")
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .background(backgroundColor.ignoresSafeArea(.all))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
