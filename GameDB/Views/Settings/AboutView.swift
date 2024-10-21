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

            // Just to be on safe side
            Section(header: Text("Disclaimer").fontWeight(.bold)) {
                Text("GameDB is not affiliated with or endorsed by any game companies, including but not limited to Apple, Sony, Microsoft, or Nintendo. All platform logos and trademarks are the property of their respective owners. Please note that the logos are used for identification purposes only, and no copyright infringement is intended.")
                    .font(.footnote)
                    .foregroundColor(.gray)
                    .padding(.top)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("About")
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
