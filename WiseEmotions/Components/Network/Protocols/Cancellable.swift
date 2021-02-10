//
//  Cancellable.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol Cancellable {
    var isCancelled: Bool { get }
    func cancel()
}

final class CancellableToken: Cancellable {
    private let token: AtomicBool = false
    private var didCancelClosure: (() -> Void)?

    var isCancelled: Bool {
        return token.value
    }

    func cancel() {
        token.value = true
        didCancelClosure?()
    }

    func didCancel(_ action: @escaping () -> Void) {
        didCancelClosure = action
    }
}
