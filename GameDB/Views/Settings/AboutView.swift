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
    
    private var emailURLString: String {
        let subject = "Feedback - \(appName)"
        // Encode the subject for URL
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "mailto:\(emailAddress)?subject=\(encodedSubject)"
    }
    
    var body: some View {
        List {
            Section(header: Text("Thank you for using \(appName)!").font(.headline)) {
                Link("Website", destination: URL(string: "https://github.com/shahparshva72/GameDB/")!)
            }
            
            Section(header: Text("Social:").fontWeight(.bold)) {
                Button("Email") {
                    if let emailURL = URL(string: emailURLString) {
                        openURL(emailURL)
                    }
                }
                Link("GitHub", destination: URL(string: "https://github.com/shahparshva72")!)
            }
            
            // Just to be on safe side
            Section(header: Text("Disclaimer").fontWeight(.bold)) {
                Text("\(appName) is not affiliated with or endorsed by any game companies, including but not limited to Apple, Sony, Microsoft, or Nintendo. All platform logos and trademarks are the property of their respective owners. Please note that the logos are used for identification purposes only, and no copyright infringement is intended.")
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
