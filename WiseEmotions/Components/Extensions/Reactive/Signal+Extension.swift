//
//  Signal+Extension.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift

extension Signal {
    static func merge(values: Signal<Value, Never>,
                      errors: Signal<Error, Never>) -> Signal<Value, Error> {
        let valuesSignal = values.promoteError(Error.self)
        let errorsSignal = errors
            .promoteError(Error.self)
            .attemptMap(Result<Value, Error>.failure)
        return Signal.merge(valuesSignal, errorsSignal)
    }
}
