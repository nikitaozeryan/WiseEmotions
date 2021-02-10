//
//  DefaultInitializable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol DefaultInitializable: Makeable {
    init()
}

extension DefaultInitializable where Value == Self {
    static func make() -> Value {
        return Self()
    }
}
