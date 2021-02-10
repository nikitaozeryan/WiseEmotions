//
//  UIImage+Resize.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import Foundation

extension UIImage {
    enum ResizeMode {
        case aspectFit
        case aspectFill
    }
    
    func resized(to size: CGSize) -> UIImage? {
        let newRect = CGRect(origin: .zero, size: size).integral
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        defer {
            UIGraphicsEndImageContext()
        }
        guard let imageRef = self.cgImage else { return nil }
        
        context.interpolationQuality = .high
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height)
        context.concatenate(flipVertical)
        context.draw(imageRef, in: newRect)
        return context.makeImage().flatMap { UIImage(cgImage: $0, scale: 1, orientation: imageOrientation) }
    }
    
    var roundedImage: UIImage {
        let rect = CGRect(origin:CGPoint(x: 0, y: 0),
                          size: size)
        UIGraphicsBeginImageContextWithOptions(size,
                                               false,
                                               1)
        UIBezierPath(roundedRect: rect,
                     cornerRadius: size.height).addClip()
        draw(in: rect)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return self }
        return image
    }
    
    func resized(to size: CGSize, mode: ResizeMode) -> UIImage? {
        let imageSize = self.size
        let hScale = imageSize.width > size.width ? imageSize.width / size.width : 1
        let vScale = imageSize.height > size.height ? imageSize.height / size.height : 1
        let scale = max(hScale, vScale)
        let newSize = CGSize(width: (imageSize.width / scale).rounded(),
                             height: (imageSize.height / scale).rounded())
        return resized(to: newSize)
    }
}
