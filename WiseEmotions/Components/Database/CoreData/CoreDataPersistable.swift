//
//  CoreDataPersistable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import CoreData

protocol CoreDataPersistable {
    associatedtype ManagedObject: NSManagedObject, PrimaryKeyProvider
    var primaryKeyValue: Any { get }
    
    func update(_ object: ManagedObject) throws
}

extension CoreDataPersistable {
    func findPredicate() -> NSPredicate {
        return NSPredicate(format: "%K == %@", argumentArray: [ManagedObject.primaryKey, primaryKeyValue])
    }
}

extension CoreDataPersistable where Self: Identifiable {
    var primaryKeyValue: Any { return id.value }
}
