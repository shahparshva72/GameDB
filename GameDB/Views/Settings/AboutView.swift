//
//  AboutView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL

    private let appName = "GamingQuest"
    private let emailAddress = "hey@thefourseas.dev"

    @AppStorage("isDarkMode") private var isDarkMode = true

    // Colors for Light and Dark modes
    private var headerColor: Color {
        isDarkMode ? .yellow : .blue
    }

    private var linkColor: Color {
        isDarkMode ? .cyan : .green
    }

    private var disclaimerColor: Color {
        isDarkMode ? .gray : .black
    }

    private var backgroundColor: Color {
        isDarkMode ? .black : .white
    }

    private var emailURLString: String {
        let subject = "Feedback - \(appName)"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "mailto:\(emailAddress)?subject=\(encodedSubject)"
    }

    var body: some View {
        List {
            Section(header: Text("Thank you for using \(appName)!")
                .font(.custom("PressStart2P-Regular", size: 14))
                .foregroundColor(headerColor))
            {
                Link("Website", destination: URL(string: "https://github.com/shahparshva72/GameDB/")!)
                    .font(.custom("PressStart2P-Regular", size: 12))
                    .foregroundColor(linkColor)
            }

            Section(header: Text("Social:")
                .font(.custom("PressStart2P-Regular", size: 14))
                .foregroundColor(headerColor))
            {
                Button("Email") {
                    if let emailURL = URL(string: emailURLString) {
                        openURL(emailURL)
                    }
                }
                .font(.custom("PressStart2P-Regular", size: 12))
                .foregroundColor(linkColor)

                Link("GitHub", destination: URL(string: "https://github.com/shahparshva72")!)
                    .font(.custom("PressStart2P-Regular", size: 12))
                    .foregroundColor(linkColor)
            }

            Section(header: Text("Disclaimer")
                .font(.custom("PressStart2P-Regular", size: 14))
                .foregroundColor(headerColor))
            {
                Text("\(appName) is not affiliated with or endorsed by any game companies, including but not limited to Apple, Sony, Microsoft, or Nintendo. All platform logos and trademarks are the property of their respective owners. Please note that the logos are used for identification purposes only, and no copyright infringement is intended.")
                    .font(.custom("PressStart2P-Regular", size: 10))
                    .lineSpacing(4)
                    .foregroundColor(disclaimerColor)
                    .padding(.top)
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("About")
        .background(backgroundColor.edgesIgnoringSafeArea(.all))
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
