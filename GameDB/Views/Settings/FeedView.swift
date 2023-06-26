//
//  FeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct FeedView: View {
    
    // TODO: - Add option for user to add RSS Feeds
    @ObservedObject var feedListModel = FeedListModel()

    var body: some View {
        VStack {
            List(feedListModel.feeds, id: \.id) { feedModel in
                Text(feedModel.name)
            }
        }
        .navigationTitle(Text("Feeds"))
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
