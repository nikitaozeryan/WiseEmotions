//
//  With.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

@discardableResult
public func with<T>(_ value: T,
                    _ builder: (inout T) throws -> Void) rethrows -> T {
    var mutableValue = value
    try builder(&mutableValue)
    return mutableValue
}

@discardableResult
public func withNonNil<T: OptionalProtocol>(_ value: T,
                                            _ builder: (inout T.Wrapped) throws -> Void) rethrows -> T {
    if var mutableValue = value.optional {
        try builder(&mutableValue)
        return T(reconstructing: mutableValue)
    } else {
        return value
    }
}
