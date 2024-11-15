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
    
    func body(content: Content) -> some View {
        content
            .font(.custom("PressStart2P-Regular", size: size))
            .foregroundColor(color ?? (isDarkMode ? .white : .black))
    }
}