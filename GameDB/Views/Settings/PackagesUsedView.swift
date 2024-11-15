//
//  PackagesUsedView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct PackagesUsedView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true

    let packages = [
        (name: "IGBD-Swift-API", url: "https://github.com/husnjak/IGDB-SWIFT-API.git"),
        (name: "Kingfisher", url: "https://github.com/onevcat/Kingfisher.git"),
        (name: "AlertToast", url: "https://github.com/elai950/AlertToast.git"),
    ]

    // Colors for Light and Dark modes
    private var linkColor: Color {
        isDarkMode ? .cyan : .green
    }

    private var backgroundColor: Color {
        isDarkMode ? .black : .white
    }

    var body: some View {
        List(packages, id: \.0) { package in
            Link(package.name, destination: URL(string: package.url)!)
                .pixelatedFont(size: 12)
                .foregroundColor(linkColor)
                .padding(.vertical, 5)
        }
        .navigationTitle("Packages Used")
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

struct PackagesUsedView_Previews: PreviewProvider {
    static var previews: some View {
        PackagesUsedView()
    }
}
