//
//  UIView+Shadow.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UIView {
    enum ShadowFrame {
        case rect
        case oval
        case roundedRect(radius: CGFloat)
        case rounded(corners: UIRectCorner, cornerRadius: CGFloat)
    }

    /**
     Adds the shadow on the layer.

     - Parameter shadowFrame: The shadow frame. Defaults to .rect.
     - Parameter offset: The shadow offset. Defaults to .zero.
     - Parameter color: The color of the shadow. Defaults to black.
     - Parameter opacity: The opacity of the shadow. Defaults to 1.
     - Parameter radius: The blur radius used to create the shadow. Defaults to 10.
     */

    func addShadow(withFrame shadowFrame: ShadowFrame = .rect,
                   offset: CGSize = .zero,
                   color: UIColor = .black,
                   opacity: CGFloat = 1,
                   radius: CGFloat = 10,
                   padding: UIEdgeInsets = .zero) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = Float(opacity)
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
        let shadowRect = bounds.inset(by: padding)
        switch shadowFrame {
        case .oval:
            layer.shadowPath = UIBezierPath(ovalIn: shadowRect).cgPath
        case .rect:
            layer.shadowPath = UIBezierPath(rect: shadowRect).cgPath
        case .roundedRect(let radius):
            layer.shadowPath = UIBezierPath(roundedRect: shadowRect, cornerRadius: radius).cgPath
        case .rounded(let corners, let cornerRadius):
            layer.shadowPath = UIBezierPath(roundedRect: shadowRect,
                                            byRoundingCorners: corners,
                                            cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        }
    }

    /**
     Hides the layer's shadow from view.
     */
    func hideShadow() {
        layer.shadowOpacity = 0
    }
    
    func showShadow() {
        layer.shadowOpacity = 1
    }
}
