//
//  FeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct FeedView: View {
    
    // TODO: - Add options for user to select RSS Feeds
    
    @State private var multiSelection = Set<FeedsModel>()
    
    var body: some View {
        VStack {
            List(FeedsModel.allCases, id: \.self, selection: $multiSelection) { feedModel in
                Text(feedModel.feed.name)
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
