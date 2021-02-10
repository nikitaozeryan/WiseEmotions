//
//  FetchRequestProvider.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import CoreData

protocol FetchRequestProvider where Self: PrimaryKeyProvider & NSManagedObject {
    associatedtype ID
    static func findPredicate(id: ID) -> NSPredicate
}

extension FetchRequestProvider {
    public static func findPredicate(id: ID) -> NSPredicate {
        NSPredicate(format: "%K == %@", argumentArray: [self.primaryKey, id])
    }
}
