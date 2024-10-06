//
//  GameCountdownView.swift
//  GameDB
//
//  Created by Parshva Shah on 11/8/23.
//

import Kingfisher
import SwiftUI

struct GameCountdownView: View {
    var game: GameDataModel

    private var daysLeft: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: game.releaseDate).day ?? 0
    }

    var body: some View {
        HStack(alignment: .center) {
            KFImage(URL(string: game.coverURLString))
                .resizable()
                .placeholder {
                    PlaceholderImage()
                }
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
                .clipped()
                .cornerRadius(10)
                .shadow(radius: 5)

            VStack(alignment: .leading) {
                Text(game.name)
                    .font(.headline)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .foregroundStyle(Color.white)

                Text("\(daysLeft) days left")
                    .font(.subheadline)
                    .foregroundStyle(Color.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(SaveGamesCategory.upcoming.color)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
