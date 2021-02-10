//
//  Command.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

public struct Command<Value> {
    public typealias Action = (Value) -> Void
    private let action: Action

    public init(_ action: @escaping Action) {
        self.action = action
    }

    public func perform(value: Value,
                        file: String = #file,
                        function: String = #function,
                        line: Int = #line) {
        action(value)
    }
}

public extension Command where Value == Void {
    func perform(file: String = #file,
                 function: String = #function,
                 line: Int = #line) {
        perform(value: ())
    }
}
