//
//  UIImage+Ext.swift
//  GameDB
//
//  Created by Parshva Shah on 5/25/23.
//

// Ref: https://medium.com/swlh/swiftui-read-the-average-color-of-an-image-c736adb43000

import SwiftUI
import UIKit

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        // disable HDR:
        format.preferredRange = .standard
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let result = renderer.image { _ in
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }
        return result
    }

    func getPixels() -> [UIColor] {
        guard let cgImage = cgImage else {
            return []
        }
        assert(cgImage.bitsPerPixel == 32, "only support 32 bit images")
        assert(cgImage.bitsPerComponent == 8, "only support 8 bit per channel")
        guard let imageData = cgImage.dataProvider?.data as Data? else {
            return []
        }
        let size = cgImage.width * cgImage.height
        let buffer = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: size)
        _ = imageData.copyBytes(to: buffer)
        var result = [UIColor]()
        result.reserveCapacity(size)
        for pixel in buffer {
            var r: UInt32 = 0
            var g: UInt32 = 0
            var b: UInt32 = 0
            if cgImage.byteOrderInfo == .orderDefault || cgImage.byteOrderInfo == .order32Big {
                r = pixel & 255
                g = (pixel >> 8) & 255
                b = (pixel >> 16) & 255
            } else if cgImage.byteOrderInfo == .order32Little {
                r = (pixel >> 16) & 255
                g = (pixel >> 8) & 255
                b = pixel & 255
            }
            let color = UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1)
            result.append(color)
        }
        return result
    }
}
