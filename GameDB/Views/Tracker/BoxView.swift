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
                    .font(.headline.weight(.bold))
                    .padding(10)
                    .background(Color.white.opacity(0.2))
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.5), radius: 10, x: 0, y: 4)

                Spacer()

                Text("\(count)")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .truncationMode(.tail)
                .lineLimit(1)
        }
        .padding(12)
        .frame(width: 160, height: 100)
        .background(LinearGradient(gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        .accessibilityElement(children: .ignore)
        .accessibility(label: Text("\(title) \(count)"))
    }
}
