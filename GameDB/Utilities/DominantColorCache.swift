//
//  DominantColorCache.swift
//  GameDB
//
//  Created by Parshva Shah on 5/31/23.
//

import UIKit

final class DominantColorCache {
    static let shared = DominantColorCache()

    private init() {}

    private var colorCache: [String: UIColor] = [:]

    func cacheColor(_ color: UIColor, for url: String) {
        colorCache[url] = color
    }

    func cachedColor(for url: String) -> UIColor? {
        return colorCache[url]
    }
}
