//
//  ShimmerView.swift
//  GameDB
//
//  Created by Parshva Shah on 10/1/24.
//

import SwiftUI

struct ShimmerView: View {
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
            Color.white.opacity(0.2)
                .mask(
                    Rectangle()
                        .fill(
                            LinearGradient(gradient: Gradient(colors: [.clear, .white.opacity(0.5), .clear]), startPoint: .leading, endPoint: .trailing)
                        )
                        .rotationEffect(.degrees(70))
                        .offset(x: shimmerOffset)
                )
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                shimmerOffset = 200
            }
        }
    }
}
