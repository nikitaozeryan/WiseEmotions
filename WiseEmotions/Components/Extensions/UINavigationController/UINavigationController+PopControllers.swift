//
//  UINavigationController+PopControllers.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UINavigationController {
    func popControllers(count: Int, animated: Bool = true) {
        guard viewControllers.count > count else { return }
        popToViewController(viewControllers[viewControllers.count - count - 1], animated: animated)
    }
}
