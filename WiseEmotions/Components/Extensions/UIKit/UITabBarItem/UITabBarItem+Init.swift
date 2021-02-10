//
//  UITabBarItem+Init.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UITabBarItem {
    convenience public init(title: String?, image: UIImage?) {
        self.init(title: title, image: image, selectedImage: image)
    }
}
