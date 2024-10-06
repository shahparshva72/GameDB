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
    @State private var dominantUIColor: UIColor = .clear

    var body: some View {
        VStack(alignment: .center) {
            KFImage.url(url)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(20)
                .onAppear {
                    ImageProcessing.getDominantColor(imageURLString: url!.absoluteString) { color, uiColor in
                        dominantColor = color
                        dominantUIColor = uiColor
                    }
                }

            Text(name)
                .font(Font.system(size: 20, weight: .bold, design: .rounded))
                .foregroundColor(dominantUIColor.perceivedBrightness < 0.5 ? Color(hex: "#FAFAFA") : Color(hex: "#121212"))
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 16))
                .background(
                    Rectangle()
                        .foregroundColor(dominantColor)
                        .opacity(0.6)
                        .blur(radius: 2.5)
                )
        }
        .padding(10)
        .background(dominantColor)
        .cornerRadius(20)
    }
}
