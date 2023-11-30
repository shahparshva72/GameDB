//
//  PackagesUsedView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct PackagesUsedView: View {
    let packages = [
        (name: "IGBD-Swift-API", url: "https://github.com/husnjak/IGDB-SWIFT-API.git"),
        (name: "Kingfisher", url: "https://github.com/onevcat/Kingfisher.git"),
        (name: "AlertToast", url: "https://github.com/elai950/AlertToast.git")
    ]

    var body: some View {
            List(packages, id: \.0) { package in
                Button(action: {
                    openURL(URL(string: package.name)!)
                }) {
                    VStack(alignment: .leading) {
                        Text(package.name)
                            .font(.headline)
                        Text(package.url)
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Packages Used")
        }

        private func openURL(_ url: URL) {
            UIApplication.shared.open(url)
        }
}

struct CreditsView_Previews: PreviewProvider {
    static var previews: some View {
        PackagesUsedView()
    }
}
