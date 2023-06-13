//
//  BackgroundModifier.swift
//  GameDB
//
//  Created by Parshva Shah on 6/2/23.
//

import SwiftUI

struct BackgroundColorModifier: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        ZStack {
            color.edgesIgnoringSafeArea(.all)
            content
        }
    }
}

extension View {
    func backgroundColor(_ color: Color) -> some View {
        self.modifier(BackgroundColorModifier(color: color))
    }
}
