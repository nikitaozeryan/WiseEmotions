//
//  CDStat.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//
//

import Foundation
import CoreData

@objc(StatEntity)
public final class StatEntity: NSManagedObject, FetchRequestProvider, ManagedObject {
    typealias ID = String
    
    @NSManaged public var value: Int64
    @NSManaged public var effort: Int64
    @NSManaged public var name: String
    @NSManaged public var id: String
    @NSManaged public var link: String
    @NSManaged public var pokemon: PokemonEntity?
}

// MARK: - PrimaryKeyProvider

extension StatEntity: PrimaryKeyProvider {
    static var primaryKey: String {
        return #keyPath(StatEntity.id)
    }
}
