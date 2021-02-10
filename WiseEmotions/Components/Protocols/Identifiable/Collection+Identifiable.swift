//
//  Collection+Identifiable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//
import Foundation

extension Collection where Element: Identifiable {
    /// Returns the first index in which an element has same `id` as givent element's `id`
    ///
    /// You can use the predicate to find an element of a type that
    /// conform to the [Identifiable](x-source-tag://Identifiable) protocol
    ///
    /// - Parameter element: An element to search for in the collection.
    /// - Returns: The first index where `element` is found. If `element` is not
    ///   found in the collection, returns `nil`.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the collection.
    func firstIndex(of element: Element) -> Index? {
        return firstIndex(where: { $0.id == element.id })
    }
}

extension RangeReplaceableCollection where Element: Identifiable {
    @discardableResult
    mutating func remove(_ element: Element) -> Element? {
        guard let index = firstIndex(of: element) else { return nil }
        return remove(at: index)
    }
}
