//
//  PlaceholderImage.swift
//  GameDB
//
//  Created by Parshva Shah on 11/21/23.
//

import SwiftUI

struct PlaceholderImage: View {
    var body: some View {
        Image(systemName: "photo")
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.gray)
            .background(Color(.secondarySystemBackground))
            .accessibilityHidden(true)
    }
}

#Preview {
    PlaceholderImage()
}
