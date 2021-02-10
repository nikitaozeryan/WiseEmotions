//
//  NetworkStrategy.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol NetworkPlugin {
    func prepare(_ request: URLRequest,
                 target: RequestConvertible) throws -> URLRequest
    func willSend(_ request: Network.Request,
                  target: RequestConvertible)
    func didReceive(_ result: Network.ResponseResult,
                    target: RequestConvertible)
    func process(_ result: Network.ResponseResult,
                 target: RequestConvertible) -> Network.ResponseResult
    func should(retry target: RequestConvertible,
                dueTo error: Error,
                completion: @escaping (Network.RetryResult) -> Void)
}

extension NetworkPlugin {
    func prepare(_ request: URLRequest,
                 target: RequestConvertible) -> URLRequest {
        return request
    }

    func willSend(_ request: Network.Request, target: RequestConvertible) {}

    func didReceive(_ result: Network.ResponseResult, target: RequestConvertible) {}

    func process(_ result: Network.ResponseResult,
                 target: RequestConvertible) -> Network.ResponseResult {
        return result
    }

    func should(retry target: RequestConvertible,
                dueTo error: Error,
                completion: @escaping (Network.RetryResult) -> Void) {
        completion(.doNotRetry)
    }
}
