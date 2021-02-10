//
//  SignalProducer+Extension.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import ReactiveSwift

extension SignalProducerConvertible
    where
    Value == Network.Response,
    Error == AppError
{
    func decode<T: Decodable>(_ type: T.Type,
                              decoder: JSONDecoder = JSONDecoder()) -> SignalProducer<T, Error> {
        return producer.attemptMap { try $0.decode(T.self, decoder: decoder) }
    }
}

extension SignalProducerConvertible
    where
    Value == Network.SocketResponse,
    Error == AppError
{
    func decode<T: Decodable>(_ type: T.Type,
                              decoder: JSONDecoder = JSONDecoder()) -> SignalProducer<T, Error> {
        return producer.attemptMap { try $0.decode(T.self, decoder: decoder) }
    }
}

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

extension SignalProducerConvertible {
    func `catch`(_ transform: @escaping (Error) -> Value) -> SignalProducer<Value, Never> {
        return producer
            .flatMapError {
                SignalProducer(value: transform($0))
            }
    }

    func ignoreError() -> SignalProducer<Value?, Never> {
        return producer
            .map(Result<Value, Error>.success)
            .flatMapError { SignalProducer<Result<Value, Error>, Never>(value: .failure($0)) }
            .map { try? $0.get() }
    }
}

extension SignalProducerConvertible where Value: OptionalProtocol {
    func ignoreError() -> SignalProducer<Value, Never> {
        return producer
            .flatMapError { _ in SignalProducer(value: Value(reconstructing: nil)) }
    }
}

extension SignalProducerConvertible {
    public func mapToVoid() -> SignalProducer<Void, Error> {
        return producer.map { _ in }
    }
}
