//
//  FeedView.swift
//  GameDB
//
//  Created by Parshva Shah on 6/1/23.
//

import SwiftUI

struct FeedView: View {
    var body: some View {
        NavigationView {
            List(FeedsModel.allCases, id: \.self) { feedModel in
                Text(feedModel.feed.name)
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
