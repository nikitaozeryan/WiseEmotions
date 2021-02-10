//
//  NSManagedObjectContext+Operations.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import CoreData
import ReactiveSwift

extension NSManagedObjectContext {
    func count<T: NSManagedObject>(typeEntity: T.Type,
                                   by predicate: NSPredicate? = nil) throws -> Int {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: typeEntity))
        fetchRequest.predicate = predicate
        return try self.count(for: fetchRequest)
    }
    
    func save(block: @escaping (NSManagedObjectContext) -> Void) -> SignalProducer<Void, AppError> {
        return SignalProducer { observer, _ in
            self.perform {
                block(self)
                if self.hasChanges {
                    do {
                        try self.save()
                    } catch {
                        observer.send(error: AppError(error))
                        return
                    }
                }
                observer.send(value: ())
                observer.sendCompleted()
            }
        }
    }
    
    func fetchAll<T: NSManagedObject>(typeEntity: T.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil) throws -> [T] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.returnsObjectsAsFaults = false
        let result = try self.fetch(fetchRequest)
        return result.compactMap{$0 as? T}
    }
    
    func fetchFirst<T: NSManagedObject>(typeEntity: T.Type,
                                        predicate: NSPredicate? = nil,
                                        sortDescriptors: [NSSortDescriptor]? = nil) throws -> T {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.self))
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.fetchLimit = 1
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let result = try self.fetch(fetchRequest)
            if let value = result.compactMap({$0 as? T}).first {
                return value
            } else {
                throw AppError.database(.notFound)
            }
        } catch {
            throw AppError.database(.notFound)
        }
    }
    
    func fetchOrCreate<Input: CoreDataPersistable>(for object: Input,
                                                   with predicate: NSPredicate) throws -> Input.ManagedObject {
        var first: Input.ManagedObject!
        do {
            first = try fetchFirst(typeEntity: Input.ManagedObject.self, predicate: predicate)
        } catch {
            if (error as? AppError)?.isNotFoundEntity == true {
                return Input.ManagedObject(entity: NSEntityDescription.entity(forEntityName: String(describing: Input.ManagedObject.self),
                                                                              in: self)!,
                                           insertInto: self)
            } else {
                throw error
            }
        }
        return first
    }
    
    func fetchOrCreate<Input: NSManagedObject>(entity type: Input.Type,
                                               with predicate: NSPredicate) throws -> Input {
        var first: Input
        do {
            first = try fetchFirst(typeEntity: Input.self, predicate: predicate)
        } catch {
            if (error as? AppError)?.isNotFoundEntity == true {
                return type.init(entity: NSEntityDescription.entity(forEntityName: String(describing: type),
                                                                    in: self)!,
                                 insertInto: self)
            } else {
                throw error
            }
        }
        return first
    }
    
    func fetchOrCreate<Input: CoreDataPersistable>(for object: Input) throws -> Input.ManagedObject {
        let predicate = object.findPredicate()
        var first: Input.ManagedObject!
        do {
            first = try fetchFirst(typeEntity: Input.ManagedObject.self, predicate: predicate)
        } catch {
            if (error as? AppError)?.isNotFoundEntity == true {
                return Input.ManagedObject(entity: NSEntityDescription.entity(forEntityName: String(describing: Input.ManagedObject.self),
                                                                              in: self)!,
                                           insertInto: self)
            } else {
                throw error
            }
        }
        return first
    }
    
    
    
    func findFirstOrCreate<Input: NSManagedObject>(entity type: Input.Type) throws -> Input {
        var first: Input
        do {
            first = try fetchFirst(typeEntity: Input.self, predicate: nil)
        } catch {
            if (error as? AppError)?.isNotFoundEntity == true {
                return type.init(entity: NSEntityDescription.entity(forEntityName: String(describing: type),
                                                                    in: self)!,
                                 insertInto: self)
            } else {
                throw error
            }
        }
        return first
    }
    
    func create<Input: NSManagedObject>(entity type: Input.Type) throws -> Input {
        return type.init(entity: NSEntityDescription.entity(forEntityName: String(describing: type),
                                                            in: self)!,
                         insertInto: self)
    }
    
    func removeAll<T: NSManagedObject>(typeEntity: T.Type,
                                       predicate: NSPredicate? = nil) throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: typeEntity))
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        fetchRequest.includesPropertyValues = false
        let fetchResult = try self.fetch(fetchRequest)
        let result = fetchResult.compactMap{$0 as? T}
        result.forEach{self.delete($0)}
    }
}

extension NSManagedObjectContext {
    func entities<T: NSManagedObject>(_ typeEntity: T.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil)
        -> SignalProducer<[T], AppError> {
            return SignalProducer { observer, lifetime in
                let request = NSFetchRequest<T>(entityName: String(describing: typeEntity))
                request.predicate = predicate
                request.sortDescriptors = sortDescriptors ?? []
                request.returnsObjectsAsFaults = false
                let dbObserver = CoreDataEntitiesObserver(fetchRequest: request, managedObjectContext: self)
                lifetime += dbObserver.values.producer.start(observer)
                lifetime.observeEnded { dbObserver.dispose() }
            }
    }
    
    func pagedEntities<T: NSManagedObject>(_ typeEntity: T.Type,
                                           predicate: NSPredicate? = nil,
                                           sortDescriptors: [NSSortDescriptor]? = nil,
                                           pagination: LimitOffset) -> SignalProducer<[T], AppError> {
        return SignalProducer { _, _ in
            let request = NSFetchRequest<T>(entityName: String(describing: typeEntity))
            request.predicate = predicate
            request.sortDescriptors = sortDescriptors ?? []
            request.fetchLimit = pagination.limit
            request.fetchOffset = pagination.offset
        }
    }
}
