//
//  ImageProcessing.swift
//  GameDB
//
//  Created by Parshva Shah on 5/26/23.
//

import Foundation
import SwiftUI
import UIKit

class ImageProcessing {
    static func getDominantColor(imageURLString: String, completion: @escaping (Color, UIColor) -> Void) {
        if let cachedColor = DominantColorCache.shared.cachedColor(for: imageURLString) {
            completion(Color(cachedColor), cachedColor)
            return
        }

        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: imageURLString),
                  let data = try? Data(contentsOf: url),
                  let uiImage = UIImage(data: data) else { return }

            let smallImage = uiImage.resized(to: CGSize(width: 100, height: 100))
            let kMeans = KMeansClusterer()
            let points = smallImage.getPixels().map { KMeansClusterer.Point(from: $0) }
            let clusters = kMeans.cluster(points: points, into: 3).sorted(by: { $0.points.count > $1.points.count })
            let uiColors = clusters.map { $0.center.toUIColor() }

            guard let mainUIColor = uiColors.first else { return }

            DispatchQueue.main.async {
                completion(Color(mainUIColor), mainUIColor)
            }

            DominantColorCache.shared.cacheColor(mainUIColor, for: imageURLString)
        }
    }
}
