//
//  Shape+Ext.swift
//  GameDB
//
//  Created by Parshva Shah on 6/2/23.
//

import SwiftUI

struct TopCornerRounded: Shape {
    var radius: CGFloat = .infinity
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let lowerRightCorner = CGPoint(x: rect.maxX, y: rect.maxY)
        let upperLeftCorner = CGPoint(x: rect.minX, y: rect.minY)
        let upperRightCorner = CGPoint(x: rect.maxX, y: rect.minY)
        
        path.move(to: upperLeftCorner)
        path.addArc(tangent1End: upperLeftCorner, tangent2End: upperRightCorner, radius: radius)
        path.addArc(tangent1End: upperRightCorner, tangent2End: lowerRightCorner, radius: radius)
        path.addLine(to: lowerRightCorner)
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        return path
    }
}
