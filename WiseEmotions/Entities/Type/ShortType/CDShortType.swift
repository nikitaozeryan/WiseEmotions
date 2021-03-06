//
//  CDShortType.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//
//

import Foundation
import CoreData

@objc(ShortTypeEntity)
public final class ShortTypeEntity: NSManagedObject, FetchRequestProvider, ManagedObject {
    typealias ID = String

    @NSManaged public var id: String
    @NSManaged public var link: String
    @NSManaged public var slot: Int64
    @NSManaged public var pokemon: PokemonEntity?
}

// MARK: - PrimaryKeyProvider

extension ShortTypeEntity: PrimaryKeyProvider {
    static var primaryKey: String {
        return #keyPath(ShortTypeEntity.id)
    }
}
