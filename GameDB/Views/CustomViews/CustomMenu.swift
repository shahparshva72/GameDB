//
//  CustomMenu.swift
//  GameDB
//
//  Created by Parshva Shah on 11/14/24.
//

import SwiftUI

struct CustomMenu<Content: View>: View {
    @State private var isMenuOpen: Bool = false
    @ViewBuilder let content: () -> Content
    let label: String
    let fontName: String
    let fontSize: CGFloat

    var menuBody: some View {
        VStack(spacing: 0) {
            content()
        }
        .padding()
    }

    var body: some View {
        VStack {
            // Label Button to open/close menu
            Button(action: {
                withAnimation {
                    isMenuOpen.toggle()
                }
            }) {
                Text(label)
                    .font(.custom(fontName, size: fontSize))
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }

            if isMenuOpen {
                // Custom drop-down menu
                GeometryReader { proxy in
                    let maxHeight = proxy.size.height

                    menuBody
                        .hidden()
                        .overlay(alignment: .top) {
                            ScrollView {
                                menuBody
                                    .background(.regularMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 13))
                                    .shadow(color: .black.opacity(0.2), radius: 40)
                            }
                            .frame(maxHeight: maxHeight)
                            .scrollBounceBehavior(.basedOnSize)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 5)
                }
                .transition(.scale(scale: 0.01, anchor: .top).combined(with: .opacity))
            }
        }
    }
}
