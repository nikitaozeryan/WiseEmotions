//
//  Type.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

struct Type {
    let id: String
    let name: String
    let slot: Int64
    let link: String
}

extension Type: CoreDataPersistable {
    typealias ManagedObject = TypeEntity
    
    var primaryKeyValue: Any {
        return id
    }
    
    func update(_ object: ManagedObject) throws {
        object.id = id
        object.link = link
        object.name = name
        object.slot = slot
    }
}

extension Type {
    init(from cdObject: TypeEntity) {
        id = cdObject.id
        link = cdObject.link
        slot = cdObject.slot
        name = cdObject.name
    }
}
