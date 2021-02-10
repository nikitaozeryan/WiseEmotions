//
//  MediaObserver.swift
//  DownloadManager
//
//  Created by Nikita Ozerian on 5/16/20.
//  Copyright © 2020 Nikita Ozerian. All rights reserved.
//

import Foundation

/// Custom mechanism to observe Media events.
/// Created as an alternative to `NotificationCenter` to have more clear and swifty syntax.

/// Represents the object that can listen to folder actions.
public protocol MediaObserver: class {
    func media(_ media: Media, didUpdateStatus status: Media.Status)
}

public extension MediaObserver {

    // Start Observation

    func observeUpdates(for media: Media) {
        observeUpdates(for: [media])
    }

    func observeUpdates(for media: Media...) {
        observeUpdates(for: media)
    }

    func observeUpdates(for media: [Media]) {

        for element in media {
            let observers = Media.observers[element] ?? .init()
            observers.insert(self)
            Media.observers[element] = observers
        }
    }

    // Stop Observation

    func stopObservingUpdates(for media: Media) {
        stopObservingUpdates(for: [media])
    }

    func stopObservingUpdates(for media: Media...) {
        stopObservingUpdates(for: media)
    }

    func stopObservingUpdates(for media: [Media]) {

        for element in media {
            guard let observers = Media.observers[element] else { continue }
            observers.remove(self)
            Media.observers[element] = observers
        }
    }
}

//

extension Media {

    /// Observers List.
    fileprivate static var observers: [Media: WeakSet<MediaObserver>] = [:]

    /// Will go through all observers object for given socket event
    /// and will call method related to this action.
    //// - Parameter event: Event about which observers will be notified.
    /// - Parameter data: JSON data that came along with the event.
    /// - Parameter queue: Operation queue, where the notification will happen.
    public func notifyObservers(about status: Status, queue: OperationQueue = .main) {
        guard let observers = Media.observers[self] else { return }
        queue.addOperation { observers.allObjects.forEach { $0.media(self, didUpdateStatus: status) } }
    }
}
