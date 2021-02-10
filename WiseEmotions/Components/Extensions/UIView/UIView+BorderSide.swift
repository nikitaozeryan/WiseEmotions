//
//  UIView+BorderSide.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UIView {
    
    func addBorder(withColor color: UIColor, width: CGFloat, rectEdge: UIRectEdge) {
        if rectEdge.contains(.top) {
            with(makeLayer(withColor: color)) {
                $0.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: width)
                layer.addSublayer($0)
            }
        }
        
        if rectEdge.contains(.bottom) {
            with(makeLayer(withColor: color)) {
                $0.frame = CGRect(x: 0, y: frame.size.height - width, width: frame.size.width, height: width)
                layer.addSublayer($0)
            }
        }
        
        if rectEdge.contains(.right) {
            with(makeLayer(withColor: color)) {
                $0.frame = CGRect(x: frame.size.width - width, y: 0, width: width, height: frame.size.height)
                layer.addSublayer($0)
            }
        }
        
        if rectEdge.contains(.left) {
            with(makeLayer(withColor: color)) {
                $0.frame = CGRect(x: 0, y: 0, width: width, height: frame.size.height)
                layer.addSublayer($0)
            }
        }
    }
    
    private func makeLayer(withColor color: UIColor) -> CALayer{
        let border = CALayer()
        border.backgroundColor = color.cgColor
        return border
    }
}
