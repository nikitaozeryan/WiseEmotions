//
//  Identifiable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

/**
 Use this protocol to give your Model typesafe identifier
 
 Example:

     struct User: Identifiable {
         var id: User.ID
         var name: String
     }
 
 - Tag: Identifiable
 */
public protocol Identifiable {
    associatedtype Identifier: Codable & Hashable = Int64
    associatedtype Owner = Self

    typealias ID = Token<Owner, Identifier>
    var id: ID { get }
}
