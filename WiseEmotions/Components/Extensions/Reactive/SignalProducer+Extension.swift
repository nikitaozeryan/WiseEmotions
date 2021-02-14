//
//  SignalProducer+Extension.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import ReactiveSwift

extension SignalProducerConvertible where Error == AppError {
    func attempt(_ transform: @escaping (Value) throws -> Void)
        -> SignalProducer<Value, Error>
    {
        return producer.attempt {
            do {
                return .success(try transform($0))
            } catch {
                return .failure(AppError(error))
            }
        }
    }
    
    func attemptMap<U>(_ transform: @escaping (Value) throws -> U)
        -> SignalProducer<U, Error>
    {
        return producer.attemptMap {
            do {
                return .success(try transform($0))
            } catch {
                return .failure(AppError(error))
            }
        }
    }
}
