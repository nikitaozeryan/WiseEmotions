//
//  CoreDataStack.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import CoreData
import ReactiveSwift

final class CoreDataStack {
    
    // MARK: - Properties
    
    var viewContext: NSManagedObjectContext { persistentContainer.viewContext }
    var defaultContext: NSManagedObjectContext {
        if Thread.isMainThread {
            return persistentContainer.viewContext
        } else {
            return backgroundContext
        }
    }
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    // MARK: - Private properties
    
    private var setupProducer: SignalProducer<CoreDataStack, AppError>?
    private var persistentContainer = NSPersistentContainer(name: "Model")
    private var persistantStoreUrl: URL?
    private var entities: [NSEntityDescription] { persistentContainer.managedObjectModel.entities }
    private var didSetup = false
    
    var setup: SignalProducer<CoreDataStack, AppError> {
        if didSetup {
            setupProducer = nil
            return SignalProducer(value: self)
        } else if let producer = setupProducer {
            return producer
        }
        let producer = SignalProducer<CoreDataStack, AppError> { [unowned self] observer, _ in
            self.persistentContainer.loadPersistentStores { [unowned self] store, error in
                if let error = error {
                    observer.send(error: AppError(error))
                } else {
                    self.persistantStoreUrl = store.url
                    self.didSetup = true
                    observer.send(value: self)
                    observer.sendCompleted()
                }
            }
            self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
        }
        setupProducer = producer
        return producer
    }
}
