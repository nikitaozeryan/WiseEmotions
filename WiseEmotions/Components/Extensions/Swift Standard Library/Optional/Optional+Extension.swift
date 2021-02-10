//
//  Optional+Extension.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Optional {
    func orThrow(_ errorExpression: @autoclosure () -> Error) throws -> Wrapped {
        guard let value = self else {
            throw errorExpression()
        }
        return value
    }

    func filter(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        return flatMap { predicate($0) ? $0 : nil }
    }
}

extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }

    var nonEmpty: Wrapped? {
        return isNilOrEmpty ? nil : self
    }
}
