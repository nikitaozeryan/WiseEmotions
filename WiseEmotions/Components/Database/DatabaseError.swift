//
//  DatabaseError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

enum DatabaseError: LocalizedError {
    case notFound(type: Any, id: Any)
}
