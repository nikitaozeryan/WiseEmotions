//
//  Tag.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

/** Link **Value** with **Owner** type, same values will not be equal for different owners.
 
 Utility type required for [Identifiable](x-source-tag://Identifiable) protocol
 */
public struct Token<Owner, Value: Codable & Hashable>: Codable, Hashable, CustomStringConvertible {
    let value: Value

    init(_ value: Value) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        value = try Value(from: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }

    public var description: String {
        return "\(value)"
    }
}

extension Token: ExpressibleByIntegerLiteral where Value == Int64 {
    public typealias IntegerLiteralType = Value

    public init(integerLiteral value: Value) {
        self.init(value)
    }
}
