//
//  Persistable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol Persistable {
    associatedtype ManagedObject
    associatedtype Context
    var primaryKey: Any { get }
    func update(_ object: ManagedObject, context: Context) throws
}

extension Persistable where Context == Void {
    func update(_ object: ManagedObject) throws {
        try update(object, context: ())
    }
}

protocol PersistableCollection {
    associatedtype Item: Persistable
    var items: [Item] { get }
}

extension Array: PersistableCollection where Element: Persistable {
    typealias Item = Element
    var items: [Item] { return self }
}
