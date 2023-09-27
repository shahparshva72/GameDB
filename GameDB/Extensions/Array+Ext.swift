//
//  Array+Ext.swift
//  GameDB
//
//  Created by Parshva Shah on 9/12/23.
//

import Foundation

extension Array {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
