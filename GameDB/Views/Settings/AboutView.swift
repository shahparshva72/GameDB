//
//  AboutView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct AboutView: View {
    var body: some View {
        List {
            Section(header: Text("Thank you for using GameDB!").font(.headline)) {
                Link("Website", destination: URL(string: "https://github.com/shahparshva72/GameDB/")!)
            }
            
            Section(header: Text("Social:").fontWeight(.bold)) {
                Link("Twitter", destination: URL(string: "https://twitter.com/sparshva72")!)
                Link("GitHub", destination: URL(string: "https://github.com/shahparshva72/")!)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("About")
    }
}

extension Bundle {
    public var icon: UIImage? {
        guard let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
              let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
              let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
              let lastIcon = iconFiles.last else {
            return nil
        }
        return UIImage(named: lastIcon)
    }
}


struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
