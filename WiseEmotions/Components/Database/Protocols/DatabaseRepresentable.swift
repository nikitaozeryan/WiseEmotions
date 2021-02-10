//
//  DatabaseRepresentable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol DatabaseRepresentable: Identifiable {
    associatedtype ManagedObject
    associatedtype Context

    init(_ object: ManagedObject, context: Context) throws
}

extension DatabaseRepresentable where Context == Void {
    init(_ object: ManagedObject) throws {
        try self.init(object, context: ())
    }
}
