//
//  NetworkError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

enum NetworkError: Error {
    case missingResponse
    case parametersEncoding(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .missingResponse:
            return "Missing response from server"
        case .parametersEncoding:
            return "Failed to encode request parameters"
        }
    }
}
