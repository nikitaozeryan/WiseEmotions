//
//  Stat.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

struct Stat {
    let id: String
    let name: String
    let value: Int64
    let effort: Int64
    let link: String
}

extension Stat: CoreDataPersistable {
    typealias ManagedObject = StatEntity
    
    var primaryKeyValue: Any {
        return id
    }
    
    func update(_ object: ManagedObject) throws {
        object.id = id
        object.link = link
        object.name = name
        object.value = value
        object.effort = effort
    }
}

extension Stat {
    init(from cdObject: StatEntity) {
        id = cdObject.id
        link = cdObject.link
        name = cdObject.name
        value = cdObject.value
        effort = cdObject.effort
    }
}
