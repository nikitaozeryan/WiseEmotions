//
//  ShortType.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

struct ShortType {
    let id: String
    let slot: Int64
    let link: String
}

struct ShortTypeWithLink {
    let link: URL
    let shortType: ShortType
    let pokemonID: Int64
    
    init?(shortType: ShortType, pokemonID: Int64) {
        guard let url = URL(string: shortType.link) else { return nil }
        link = url
        self.pokemonID = pokemonID
        self.shortType = shortType
    }
}

extension ShortType: CoreDataPersistable {
    typealias ManagedObject = ShortTypeEntity
    
    var primaryKeyValue: Any {
        return link
    }
    
    func update(_ object: ManagedObject) throws {
        object.id = id
        object.slot = slot
        object.link = link
    }
}

extension ShortType {
    init(from cdObject: ShortTypeEntity) {
        link = cdObject.link
        slot = cdObject.slot
        id = cdObject.id
    }
}
