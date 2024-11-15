//
//  BoxView.swift
//  GameDB
//
//  Created by Parshva Shah on 10/3/23.
//

import SwiftUI

struct BoxView: View {
    var symbolName: String
    var title: String
    var count: Int
    var categoryColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(systemName: symbolName)
                    .font(.headline.weight(.bold).width(.expanded))
                    .padding(10)
                    .background(Color.white.opacity(0.3))
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .shadow(color: categoryColor.opacity(0.8), radius: 10, x: 0, y: 5) // Neon-like glow

                Spacer()

                Text("\(count)")
                    .pixelatedFont(size: 16)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black, radius: 1, x: 0, y: 2)
            }

            Spacer()

            Text(title)
                .pixelatedFont(size: 12)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .lineSpacing(4)
                .shadow(color: .black, radius: 1, x: 0, y: 2)
        }
        .padding(12)
        .aspectRatio(3 / 2, contentMode: .fill)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.7)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(15)
        .overlay(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.white.opacity(0.4), lineWidth: 2) // Pixelated border effect
        )
//        .shadow(color: categoryColor.opacity(0.6), radius: 10, x: 0, y: 8) // Deeper shadow for depth
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("\(title) \(count)"))
        .scaleEffect(1.05) // Slight enlargement for emphasis
    }
}
