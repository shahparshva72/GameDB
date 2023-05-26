//
//  PlatformModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/22.
//

import Foundation

enum PlatformModel: Int, CaseIterable {
    case ps4 = 48
    case xboxone = 49
    case nswitch = 130
    case ps5 = 167
    case xboxSeries = 169
    
    var description: String {
        switch self {
        case .ps4:
            return "PS4"
        case .xboxone:
            return "Xbox One"
        case .nswitch:
            return "Nintendo Switch"
        case .ps5:
            return "PS5"
        case .xboxSeries:
            return "Xbox Series"
        }
    }
    
    var assetName: String {
        switch self {
        case .ps4:
            return "ps4"
        case .xboxone:
            return "xbox"
        case .nswitch:
            return "switch"
        case .ps5:
            return "ps5"
        case .xboxSeries:
            return "xbox"
        }
    }
}
