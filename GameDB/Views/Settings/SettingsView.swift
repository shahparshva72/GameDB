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
        isDarkMode ? .yellow : .blue
    }
    
    private var labelColor: Color {
        isDarkMode ? .cyan : .green
    }
    
    private var onboardingLabelColor: Color {
        isDarkMode ? .green : .purple
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
                
                Section(header: Text("General Settings")
                    .pixelatedFont(size: 14, color: headerColor))
                {
                    ForEach(SettingsModel.allCases, id: \.self) { setting in
                        NavigationLink(destination: setting) {
                            Label(setting.rawValue, systemImage: setting.icons)
                                .pixelatedFont(size: 12, color: labelColor)
                        }
                    }
                    
                    Label("Show Onboarding", systemImage: "apps.iphone")
                        .pixelatedFont(size: 12, color: onboardingLabelColor)
                        .onTapGesture {
                            isOnboardingComplete.toggle()
                        }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Settings")
                        .pixelatedFont(size: 14)
                        .padding(.leading, 10)
                }
            })
            .listStyle(.insetGrouped)
            .navigationBarTitleDisplayMode(.inline)
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
