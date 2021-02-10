//
//  Int+KFormatted.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Int {
    func kFormatted() -> String {
        guard (self / 1000) >= 1 else { return "\(self)" }
        return self >= 1000000 ? "\(self / 1000000)m" : "\(self / 1000)k"
    }
    
    var isZero: Bool {
        self == .zero
    }
}
