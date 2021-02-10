//
//  ShortStat.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

struct ShortStat {
    let id: String
    let value: Int64
    let effort: Int64
    let link: String
}

struct ShortStatWithLink {
    let link: URL
    let shortStat: ShortStat
    let pokemonID: Int64
    
    init?(shortStat: ShortStat, pokemonID: Int64) {
        guard let url = URL(string: shortStat.link) else { return nil }
        link = url
        self.pokemonID = pokemonID
        self.shortStat = shortStat
    }
}

extension ShortStat: CoreDataPersistable {
    typealias ManagedObject = ShortStatEntity
    
    var primaryKeyValue: Any {
        return link
    }
    
    func update(_ object: ManagedObject) throws {
        object.id = id
        object.value = value
        object.effort = effort
        object.link = link
    }
}

extension ShortStat {
    init(from cdObject: ShortStatEntity) {
        link = cdObject.link
        value = cdObject.value
        effort = cdObject.effort
        id = cdObject.id
    }
}
