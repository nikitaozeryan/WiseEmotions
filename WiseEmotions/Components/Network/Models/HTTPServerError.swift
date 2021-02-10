//
//  HTTPServerError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

enum HTTPServerError: LocalizedError {
    case internalServerError
    case serviceUnavailable

    init?(statusCode: Int) {
        switch statusCode {
        case 500:
            self = .internalServerError
        case 501 ..< 600:
            self = .serviceUnavailable
        default:
            return nil
        }
    }

    var errorDescription: String? {
        switch self {
        case .internalServerError:
            return "Internal Server Error"
        case .serviceUnavailable:
            return "Service Unavailable"
        }
    }
}
