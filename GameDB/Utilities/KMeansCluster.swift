//
//  KMeansCluster.swift
//  GameDB
//
//  Created by Parshva Shah on 5/26/23.
//

// Ref: https://github.com/neriusv/dominant-color-swift-sample/blob/master/kmeans/KMeansClusterer.swift

import Foundation
import UIKit

class KMeansClusterer {
    func cluster(points: [Point], into k: Int) -> [Cluster] {
        var clusters = [Cluster]()
        for _ in 0 ..< k {
            var p = points.randomElement()
            while p == nil || clusters.contains(where: { $0.center == p }) {
                p = points.randomElement()
            }
            clusters.append(Cluster(center: p!))
        }

        for _ in 0 ..< 10 {
            for cluster in clusters {
                cluster.points.removeAll()
            }
            for p in points {
                let closest = findClosest(for: p, from: clusters)
                closest.points.append(p)
            }
            var converged = true
            for cluster in clusters {
                let oldCenter = cluster.center
                cluster.updateCenter()
                if oldCenter.distanceSquared(to: cluster.center) > 0.001 {
                    converged = false
                }
            }
            if converged {
                break
            }
        }
        return clusters
    }

    private func findClosest(for p: Point, from clusters: [Cluster]) -> Cluster {
        return clusters.min(by: { $0.center.distanceSquared(to: p) < $1.center.distanceSquared(to: p) })!
    }
}

extension KMeansClusterer {
    class Cluster {
        var points = [Point]()
        var center: Point
        init(center: Point) {
            self.center = center
        }

        func calculateCurrentCenter() -> Point {
            if points.isEmpty {
                return Point.zero
            }
            return points.reduce(Point.zero, +) / points.count
        }

        func updateCenter() {
            if points.isEmpty {
                return
            }
            let currentCenter = calculateCurrentCenter()
            center = points.min(by: { $0.distanceSquared(to: currentCenter) < $1.distanceSquared(to: currentCenter) })!
        }
    }
}

extension KMeansClusterer {
    struct Point: Equatable {
        let x: CGFloat
        let y: CGFloat
        let z: CGFloat
        init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat) {
            self.x = x
            self.y = y
            self.z = z
        }

        init(from color: UIColor) {
            var r: CGFloat = 0
            var g: CGFloat = 0
            var b: CGFloat = 0
            var a: CGFloat = 0
            if color.getRed(&r, green: &g, blue: &b, alpha: &a) {
                x = r
                y = g
                z = b
            } else {
                x = 0
                y = 0
                z = 0
            }
        }

        static let zero = Point(0, 0, 0)
        static func == (lhs: Point, rhs: Point) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
        }

        static func + (lhs: Point, rhs: Point) -> Point {
            return Point(lhs.x + rhs.x, lhs.y + rhs.y, lhs.z + rhs.z)
        }

        static func / (lhs: Point, rhs: CGFloat) -> Point {
            return Point(lhs.x / rhs, lhs.y / rhs, lhs.z / rhs)
        }

        static func / (lhs: Point, rhs: Int) -> Point {
            return lhs / CGFloat(rhs)
        }

        func distanceSquared(to p: Point) -> CGFloat {
            return (x - p.x) * (x - p.x)
                + (y - p.y) * (y - p.y)
                + (z - p.z) * (z - p.z)
        }

        func toUIColor() -> UIColor {
            return UIColor(red: x, green: y, blue: z, alpha: 1)
        }
    }
}
