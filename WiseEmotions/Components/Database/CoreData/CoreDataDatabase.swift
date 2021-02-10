//
//  CoreDataDatabase.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import ReactiveSwift
import CoreData

final class CoreDataDatabase {
    
    // MARK: - Private properties
    
    private let managedObjectsTypes: [NSManagedObject.Type] = []/*[AchievementEntity.self,
                                                               MediaEntity.self,
                                                               URLEntity.self,
                                                               CurrentUserEntity.self,
                                                               InterlocutorEntity.self,
                                                               MessageEntity.self,
                                                               ChatEntity.self] */
    private let database = CoreDataStack()
    
    // MARK: - Properties
    
    var setupProducer: SignalProducer<CoreDataStack, AppError> {
        database.setup
    }
    
    private(set) lazy var contextProducer: AsyncTask<NSManagedObjectContext> = {
        database.setup.map(\.defaultContext)
    }()
    private(set) lazy var viewContextProducer: AsyncTask<NSManagedObjectContext> = {
        database.setup.map(\.viewContext)
    }()
    private(set) lazy var childViewContextProducer: AsyncTask<NSManagedObjectContext> = {
        database.setup.map(\.viewContext).map {
            let childContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            childContext.parent = $0
            childContext.automaticallyMergesChangesFromParent = true
            return childContext
        }
    }()
    
    // MARK: - Helper methods
    
    func entities<T: NSManagedObject>(_ typeEntity: T.Type,
                                      predicate: NSPredicate? = nil,
                                      sortDescriptors: [NSSortDescriptor]? = nil) -> SignalProducer<[T], AppError> {
        contextProducer.flatMap(.latest) { context -> SignalProducer<[T], AppError> in
            context.entities(T.self, predicate: predicate, sortDescriptors: sortDescriptors)
        }
    }
    
    func pagedEntities<T: NSManagedObject>(_ typeEntity: T.Type,
                                           predicate: NSPredicate? = nil,
                                           sortDescriptors: [NSSortDescriptor]? = nil,
                                           pagination: LimitOffset) -> SignalProducer<[T], AppError> {
        contextProducer.flatMap(.latest) { context -> SignalProducer<[T], AppError> in
            context.pagedEntities(T.self, predicate: predicate, sortDescriptors: sortDescriptors, pagination: pagination)
        }
    }
    
    func perform<Output>(_ action: @escaping (NSManagedObjectContext) throws -> Output )
        -> SignalProducer<Output, AppError> {
        contextProducer.flatMap(.latest) { context -> SignalProducer<Output, AppError> in
            SignalProducer { observer, _ in
                do {
                    let output = try action(context)
                    observer.send(value: output)
                    observer.sendCompleted()
                } catch {
                    observer.send(error: AppError(error))
                }
            }
        }
    }
    
    func performWrite<Input: CoreDataPersistable>(_ object: Input) -> SignalProducer<Input, AppError> {
        contextProducer.attemptMap({ context -> Input in
            let entity = try context.fetchOrCreate(for: object)
            try object.update(entity)
            if context.hasChanges {
                try context.save()
            }
            return object
        })
    }

    func performWrite<Input: Collection>(_ collection: Input)
        -> SignalProducer<Input, AppError> where Input.Element: CoreDataPersistable {
        contextProducer.attemptMap({ context -> Input in
            try collection.forEach { object in
                let entity = try context.fetchOrCreate(for: object)
                try object.update(entity)
            }
            if context.hasChanges {
                try context.save()
            }
            return collection
        })
    }
    
    func performToViewContext<Output>(_ action: @escaping (NSManagedObjectContext) throws -> Output )
        -> AsyncTask<Output> {
            viewContextProducer.attemptMap {
                try action($0)
            }
    }
    
    func performToChildViewContext<Output>(_ action: @escaping (NSManagedObjectContext) throws -> Output )
        -> AsyncTask<Output> {
            childViewContextProducer.attemptMap {
                try action($0)
            }
    }

    func destroy() -> SignalProducer<Void, AppError> {
        viewContextProducer.attemptMap({ context -> Void in
            context.performAndWait {
                self.managedObjectsTypes.forEach {
                    let request = NSBatchDeleteRequest(fetchRequest: $0.fetchRequest())
                    request.resultType = .resultTypeObjectIDs
                    do {
                        let result = try context.execute(request) as? NSBatchDeleteResult
                        let objectIDArray = result?.result as? [NSManagedObjectID]
                        let changes = [NSDeletedObjectsKey : objectIDArray]
                        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes.compactMapValues { $0 } as [AnyHashable : Any],
                                                            into: [context])
                    } catch {
                        #if DEBUG
                        print("Entity name = \($0). \n Core Data Error: Can’t delete all entities form persistens store: \n \(error)")
                        #endif
                    }
                }
            }
        })
    }
}
