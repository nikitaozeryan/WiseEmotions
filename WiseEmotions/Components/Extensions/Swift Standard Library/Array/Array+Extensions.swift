//
//  Array+Extensions.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Array {
    func replaceElement(with newValue: Element, where predicate: (Element) throws -> Bool) rethrows -> Array {
        try with(self) { try $0.replacedElement(with: newValue, where: predicate) }
    }
    
    mutating func replacedElement(with newValue: Element, where predicate: (Element) throws -> Bool) rethrows {
        guard let index = try firstIndex(where: predicate) else { return }
        self[index] = newValue
    }
    
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}
