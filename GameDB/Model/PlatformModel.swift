//
//  PlatformModel.swift
//  GameDB
//
//  Created by Parshva Shah on 5/23/22.
//

import Foundation
import Combine

enum PlatformModel: Int, CaseIterable {
    case ps5 = 167
    case xboxSeriesX = 169
    case xboxSeriesS = 170
    case nswitch = 130
    case pc = 6
    case ios = 39
    case android = 34
    case ps4 = 48
    case mac = 14

    var description: String {
        switch self {
        case .ps5:
            return "PS5"
        case .xboxSeriesX:
            return "Xbox Series X"
        case .xboxSeriesS:
            return "Xbox Series S"
        case .nswitch:
            return "Nintendo Switch"
        case .pc:
            return "PC"
        case .ios:
            return "iOS"
        case .android:
            return "Android"
        case .ps4:
            return "PS4"
        case .mac:
            return "macOS"
        }
    }
    
    var assetName: String {
        switch self {
        case .ps5:
            return "ps5"
        case .xboxSeriesX:
            return "xbox"
        case .xboxSeriesS:
            return "xbox"
        case .nswitch:
            return "switch"
        case .pc:
            return "pc"
        case .ios:
            return "ios"
        case .android:
            return "android"
        case .ps4:
            return "ps4"
        case .mac:
            return "mac"
        }
    }
}
