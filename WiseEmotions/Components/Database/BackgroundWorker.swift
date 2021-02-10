//
//  BackgroundWorker.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import ReactiveSwift

final class BackgroundWorker: NSObject {
    typealias Action = () -> Void
    struct Task {
        let action: Action
        let disposable: Disposable
    }

    private let thread: Thread

    deinit {
        stop()
    }

    init(name: String? = nil) {
        thread = Thread {
            let runloop = RunLoop.current
            runloop.add(NSMachPort(), forMode: .default)
            while !Thread.current.isCancelled {
                runloop.run(mode: .default, before: Date.distantFuture)
            }
        }
        super.init()
        thread.name = name
        thread.start()
    }

    public func stop() {
        thread.cancel()
    }

    @discardableResult
    public func perform(action: @escaping Action) -> Disposable {
        let disposable = AnyDisposable()
        let task = Task(action: action, disposable: disposable)
        if Thread.current == thread {
            action()
        } else {
            perform(#selector(runAction(_:)), on: thread, with: task, waitUntilDone: false)
        }
        return disposable
    }

    @discardableResult
    public func perform(after delay: TimeInterval, action: @escaping Action) -> Disposable {
        let disposable = CompositeDisposable()
        disposable += perform {
            guard !disposable.isDisposed else { return }
            let task = Task(action: action, disposable: disposable)
            self.perform(#selector(self.runAction(_:)), with: task, afterDelay: delay)
        }
        return disposable
    }

    // MARK: - Private

    @objc private func runAction(_ task: Any?) {
        guard let task = task as? Task, !task.disposable.isDisposed else { return }
        task.action()
    }
}

extension BackgroundWorker: DateScheduler {
    var currentDate: Date {
        return Date()
    }

    func schedule(after date: Date, action: @escaping () -> Void) -> Disposable? {
        let delay = max(0, date.timeIntervalSince(currentDate))
        return perform(after: delay, action: action)
    }

    func schedule(after date: Date, interval: DispatchTimeInterval,
                  leeway: DispatchTimeInterval,
                  action: @escaping () -> Void) -> Disposable? {
        let timeInterval = interval.timeInterval ?? 0
        let delay = max(0, date.timeIntervalSince(currentDate)) + timeInterval
        return perform(after: delay, action: action)
    }

    func schedule(_ action: @escaping () -> Void) -> Disposable? {
        return perform(action: action)
    }
}

extension DispatchTimeInterval {
    var timeInterval: TimeInterval? {
        switch self {
        case .seconds(let value):
            return TimeInterval(value)
        case .milliseconds(let value):
            return TimeInterval(value) / 1_000
        case .microseconds(let value):
            return TimeInterval(value) / 1_000_000
        case .nanoseconds(let value):
            return TimeInterval(value) / 1_000_000_000
        case .never:
            return nil
        @unknown default:
            return nil
        }
    }
}
