//
//  UIImage+Hex.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UIColor {

    // MARK: - Initialization

    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt32 = 0

        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }

        if length == 6 {
            red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            red = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    // MARK: - Computed Properties

    var toHex: String? {
        return toHex()
    }

    // MARK: - From UIColor to String

    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }

        let red = Float(components[0])
        let green = Float(components[1])
        let blue = Float(components[2])
        var opacity = Float(1.0)

        if components.count >= 4 {
            opacity = Float(components[3])
        }

        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX",
                          lroundf(red * 255),
                          lroundf(green * 255),
                          lroundf(blue * 255),
                          lroundf(opacity * 255))
        } else {
            return String(format: "%02lX%02lX%02lX",
                          lroundf(red * 255),
                          lroundf(green * 255),
                          lroundf(blue * 255))
        }
    }

}
