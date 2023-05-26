//
//  UIImage+Ext.swift
//  GameDB
//
//  Created by Parshva Shah on 5/25/23.
//

// Ref: https://medium.com/swlh/swiftui-read-the-average-color-of-an-image-c736adb43000

import UIKit
import SwiftUI

//extension UIImage {
//    /// Average color of the image, nil if it cannot be found
//    var averageColor: UIColor? {
//        // convert our image to a Core Image Image
//        guard let inputImage = CIImage(image: self) else { return nil }
//
//        // Create an extent vector (a frame with width and height of our current input image)
//        let extentVector = CIVector(x: inputImage.extent.origin.x,
//                                    y: inputImage.extent.origin.y,
//                                    z: inputImage.extent.size.width,
//                                    w: inputImage.extent.size.height)
//
//        // create a CIAreaAverage filter, this will allow us to pull the average color from the image later on
//        guard let filter = CIFilter(name: "CIAreaAverage",
//                                  parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
//        guard let outputImage = filter.outputImage else { return nil }
//
//        // A bitmap consisting of (r, g, b, a) value
//        var bitmap = [UInt8](repeating: 0, count: 4)
//        let context = CIContext(options: [.workingColorSpace: kCFNull!])
//
//        // Render our output image into a 1 by 1 image supplying it our bitmap to update the values of (i.e the rgba of the 1 by 1 image will fill out bitmap array
//        context.render(outputImage,
//                       toBitmap: &bitmap,
//                       rowBytes: 4,
//                       bounds: CGRect(x: 0, y: 0, width: 1, height: 1),
//                       format: .RGBA8,
//                       colorSpace: nil)
//
//        // Convert our bitmap images of r, g, b, a to a UIColor
//        return UIColor(red: CGFloat(bitmap[0]) / 255,
//                       green: CGFloat(bitmap[1]) / 255,
//                       blue: CGFloat(bitmap[2]) / 255,
//                       alpha: CGFloat(bitmap[3]) / 255)
//    }
//}


import UIKit

extension UIImage {

    func resized(to size : CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        //disable HDR:
        format.preferredRange = .standard
        let renderer = UIGraphicsImageRenderer(size: size, format: format)
        let result = renderer.image { (context) in
            self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        }
        return result
    }
    func getPixels() -> [UIColor] {
        guard let cgImage = self.cgImage else {
            return []
        }
        assert(cgImage.bitsPerPixel == 32, "only support 32 bit images")
        assert(cgImage.bitsPerComponent == 8,  "only support 8 bit per channel")
        guard let imageData = cgImage.dataProvider?.data as Data? else {
            return []
        }
        let size = cgImage.width * cgImage.height
        let buffer = UnsafeMutableBufferPointer<UInt32>.allocate(capacity: size)
        _ = imageData.copyBytes(to: buffer)
        var result = [UIColor]()
        result.reserveCapacity(size)
        for pixel in buffer {
            var r : UInt32 = 0
            var g : UInt32 = 0
            var b : UInt32 = 0
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
