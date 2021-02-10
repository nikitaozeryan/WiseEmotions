//
//  CoreDataEntitiesObserver.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import CoreData
import ReactiveSwift

final class CoreDataEntitiesObserver<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate, Disposable {

    // MARK: - Properties

    private let observer = Signal<[T], AppError>.pipe()
    private let frc: NSFetchedResultsController<T>
    private(set) var isDisposed: Bool = false

    var values: Signal<[T], AppError> { return observer.output }

    // MARK: - Lifecycle

    init(fetchRequest: NSFetchRequest<T>,
         managedObjectContext context: NSManagedObjectContext) {
        self.frc = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        frc.delegate = self
        context.perform { [observer] in
            do {
                try self.frc.performFetch()
            } catch let error {
                observer.input.send(error: .init(error))
            }
            self.sendNextValue()
        }
    }

    // MARK: - Actions

    private func sendNextValue() {
        self.frc.managedObjectContext.perform { [frc,observer] in
            observer.input.send(value: frc.fetchedObjects ?? [])
        }
    }

    func dispose() {
        observer.input.sendCompleted()
        frc.delegate = nil
        isDisposed = true
    }

    // MARK: - NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendNextValue()
    }
}
