//
//  AtomicBool.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

class AtomicBool: ExpressibleByBooleanLiteral {
    private var storage = UnsafeMutablePointer<Int32>.allocate(capacity: 1)

    public required init(booleanLiteral value: Bool) {
        storage.initialize(to: value ? 1 : 0)
    }

    deinit {
        storage.deinitialize(count: 1)
        storage.deallocate()
    }

    var value: Bool {
        get {
            return storage.pointee != 0
        }
        set {
            OSAtomicCompareAndSwap32Barrier(value ? 1 : 0,
                                            newValue ? 1 : 0,
                                            storage)
        }
    }
}
