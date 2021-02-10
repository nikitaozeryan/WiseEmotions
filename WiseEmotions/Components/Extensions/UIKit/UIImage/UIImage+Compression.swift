//
//  UIImage+Compression.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

typealias BytesCount = Int

extension UIImage {
    func compress(to size: BytesCount,
                  completion: @escaping ((UIImage) -> Void),
                  deltaStep: CGFloat = 0.05,
                  quality: CGFloat = 1.0) {
        var needComprassion = true
        var comprassionDelta: CGFloat = 1.0
        
        while needComprassion {
            if let image = resized(to: CGSize(width: self.size.width * comprassionDelta, height: self.size.height * comprassionDelta)),
                let data = image.jpegData(compressionQuality: quality)
            {
                if data.count <= size || comprassionDelta <= deltaStep {
                    needComprassion = false
                    completion(image)
                } else {
                    comprassionDelta -= deltaStep
                }
            } else {
                completion(self)
            }
        }
    }
    static let compressionQuality: CGFloat = 1.0
}
