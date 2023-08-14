//
//  PlatformsListView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/18/23.
//

import SwiftUI

struct PlatformsListView: View {
    
    @ObservedObject var platformsList = PlatformsList()
    
    var body: some View {
        List(platformsList.platforms) { platform in
            VStack {
                Text("\(platform.name) - \(platform.id)")
            }
            .onAppear {
                print("\(platform.name) - \(platform.id)")
            }
        }
        .onAppear {
            self.platformsList.fetchPlatform()
        }
    }
}

struct PlatformsListView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformsListView()
    }
}
