//
//  Pokemon.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

struct Pokemon {
    let id: Int64
    let name: String
    let imageURL: URL?
    let imageURLS: [URL]
    let shortStats: [ShortStat]
    let shortTypes: [ShortType]
    let stats: [Stat]
    let types: [Type]
}

extension Pokemon: CoreDataPersistable {
    typealias ManagedObject = PokemonEntity
    
    var primaryKeyValue: Any {
        return id
    }
    
    func update(_ object: ManagedObject) throws {
        object.id = id
        object.name = name
        object.imageLink = imageURL?.absoluteString
        object.imageLinks = imageURLS.map { $0.absoluteString }
    }
}

extension Pokemon {
    init(from cdObject: PokemonEntity) {
        id = cdObject.id
        name = cdObject.name
        imageURL = cdObject.imageLink.flatMap { URL(string: $0) }
        shortStats = cdObject.shortStatsArray.map(ShortStat.init)
        shortTypes = cdObject.shortTypesArray.map(ShortType.init)
        stats = cdObject.statsArray.map(Stat.init)
        types = cdObject.typesArray.map(Type.init)
        imageURLS = cdObject.imageLinks?.compactMap { URL(string: $0) } ?? []
    }
}
