//
//  CDShortStat.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//
//

import Foundation
import CoreData

@objc(ShortStatEntity)
public final class ShortStatEntity: NSManagedObject, FetchRequestProvider, ManagedObject {
    typealias ID = String
    
    @NSManaged public var id: String
    @NSManaged public var value: Int64
    @NSManaged public var effort: Int64
    @NSManaged public var link: String
    @NSManaged public var pokemon: PokemonEntity?
}

// MARK: - PrimaryKeyProvider

extension ShortStatEntity: PrimaryKeyProvider {
    static var primaryKey: String {
        return #keyPath(ShortStatEntity.id)
    }
}
