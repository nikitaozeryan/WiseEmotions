//
//  ManagedObject.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import CoreData

public protocol ManagedObject: AnyObject, NSFetchRequestResult {
    static var entityName: String { get }
    static var fetchRequest: NSFetchRequest<Self> { get }
}
public extension ManagedObject {
    static var entityName: String { NSStringFromClass(Self.self) }
    static var fetchRequest: NSFetchRequest<Self> { NSFetchRequest<Self>(entityName: entityName) }
}
