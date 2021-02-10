//
//  ApiErrorStatus.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension APIError {
    enum Status {
        case unauthorized
        case paymentRequired
        case forbidden
        case notFound
        case methodNotAllowed
        case notAcceptable
        case requestTimeout
        case unprocessable
        case serverError
        case other
    }
}
