//
//  CDPokemon.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//
//

import Foundation
import CoreData

@objc(PokemonEntity)
public final class PokemonEntity: NSManagedObject, FetchRequestProvider, ManagedObject {
    typealias ID = Int64

    @NSManaged public var id: Int64
    @NSManaged public var name: String
    @NSManaged public var imageLink: String?
    @NSManaged public var type: String?
    @NSManaged public var shortStats: NSSet?
    @NSManaged public var stats: NSSet?
    @NSManaged public var types: NSSet?
    @NSManaged public var shortTypes: NSSet?
    
    public var statsArray: [StatEntity] {
        stats?.compactMap { $0 as? StatEntity } ?? []
    }
    public var typesArray: [TypeEntity] {
        types?.compactMap { $0 as? TypeEntity } ?? []
    }
    public var shortStatsArray: [ShortStatEntity] {
        shortStats?.compactMap { $0 as? ShortStatEntity } ?? []
    }
    public var shortTypesArray: [ShortTypeEntity] {
        shortTypes?.compactMap { $0 as? ShortTypeEntity } ?? []
    }
}

// MARK: - PrimaryKeyProvider

extension PokemonEntity: PrimaryKeyProvider {
    static var primaryKey: String {
        return #keyPath(PokemonEntity.id)
    }
}


// MARK: Generated accessors for shortStats

extension PokemonEntity {

    @objc(addShortStatsObject:)
    @NSManaged public func addToShortStats(_ value: ShortStatEntity)

    @objc(removeShortStatsObject:)
    @NSManaged public func removeFromShortStats(_ value: ShortStatEntity)

    @objc(addShortStats:)
    @NSManaged public func addToShortStats(_ values: NSSet)

    @objc(removeShortStats:)
    @NSManaged public func removeFromShortStats(_ values: NSSet)

}

// MARK: Generated accessors for stats

extension PokemonEntity {

    @objc(addStatsObject:)
    @NSManaged public func addToStats(_ value: StatEntity)

    @objc(removeStatsObject:)
    @NSManaged public func removeFromStats(_ value: StatEntity)

    @objc(addStats:)
    @NSManaged public func addToStats(_ values: NSSet)

    @objc(removeStats:)
    @NSManaged public func removeFromStats(_ values: NSSet)

}

// MARK: Generated accessors for types

extension PokemonEntity {

    @objc(addTypesObject:)
    @NSManaged public func addToTypes(_ value: TypeEntity)

    @objc(removeTypesObject:)
    @NSManaged public func removeFromTypes(_ value: TypeEntity)

    @objc(addTypes:)
    @NSManaged public func addToTypes(_ values: NSSet)

    @objc(removeTypes:)
    @NSManaged public func removeFromTypes(_ values: NSSet)

}

// MARK: Generated accessors for shortTypes

extension PokemonEntity {

    @objc(addShortTypesObject:)
    @NSManaged public func addToShortTypes(_ value: ShortTypeEntity)

    @objc(removeShortTypesObject:)
    @NSManaged public func removeFromShortTypes(_ value: ShortTypeEntity)

    @objc(addShortTypes:)
    @NSManaged public func addToShortTypes(_ values: NSSet)

    @objc(removeShortTypes:)
    @NSManaged public func removeFromShortTypes(_ values: NSSet)

}
