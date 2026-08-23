//
//  GameThumbnail.swift
//  GameDB
//
//  Created by Parshva Shah on 5/22/23.
//

import Kingfisher
import SwiftUI

struct GameThumbnail: View {
    var url: URL?
    var name: String

    @State private var dominantColor: Color = .clear

    var body: some View {
        VStack(alignment: .center) {
            KFImage.url(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(20)
                .accessibilityHidden(true)
                .onAppear {
                    guard let url else { return }
                    ImageProcessing.getDominantColor(imageURLString: url.absoluteString) { color, _ in
                        dominantColor = color
                    }
                }

            Text(name)
                .pixelatedFont(size: 12, color: .white)
                .multilineTextAlignment(.center)
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 16))
                .background {
                    ZStack {
                        dominantColor
                        Color.black.opacity(0.65)
                    }
                }
        }
        .padding(10)
        .background(dominantColor)
        .cornerRadius(20)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(name)
    }
}
