//
//  UIView+Extensions.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

public extension UIView {
    
    // MARK: - IBInspectable
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }
    
    @IBInspectable var masksToBounds: Bool {
        get { return layer.masksToBounds }
        set { layer.masksToBounds = newValue }
    }
    
    @IBInspectable var colorOfBorder: UIColor {
        get { guard let color = layer.borderColor else { return .clear }
            return UIColor(cgColor: color)
        }
        set { layer.borderColor = newValue.cgColor }
    }
    
    func asImage() -> UIImage {
        UIGraphicsImageRenderer(bounds: bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
