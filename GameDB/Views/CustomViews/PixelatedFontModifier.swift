//
//  PixelatedFontModifier.swift
//  GameDB
//
//  Created by Parshva Shah on 11/15/24.
//


import SwiftUI

extension View {
    func pixelatedFont(size: CGFloat, color: Color? = nil) -> some View {
        self.modifier(PixelatedFontModifier(size: size, color: color))
    }
}

struct PixelatedFontModifier: ViewModifier {
    let size: CGFloat
    let color: Color?
    @AppStorage("isDarkMode") private var isDarkMode = true
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private var accessibleFont: Font {
        switch size {
        case 18...:
            return .title2
        case 14...:
            return .headline
        default:
            return .body
        }
    }
    
    func body(content: Content) -> some View {
        content
            .lineSpacing(4)
            .font(
                dynamicTypeSize.isAccessibilitySize
                    ? accessibleFont
                    : .custom("PressStart2P-Regular", size: size, relativeTo: .body)
            )
            .foregroundColor(color ?? (isDarkMode ? .white : .black))
    }
}
