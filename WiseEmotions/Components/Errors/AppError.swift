//
//  AppError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

enum AppError: Error {
    enum Database {
        case notFound
    }
    
    case logic(String)
    case database(Database)
    case underlying(Error)
    case decoding(DecodingError)
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .logic(let description):
            return description
        case .underlying(let error):
            return error.localizedDescription
        case .decoding(let error):
            return error.localizedDescription
        case .database(let result):
            guard case .notFound = result else {
                return "Something went wrong. Try again later"
            }
            return "No objects found for the request"
        }
    }
}

extension AppError {
    init(_ error: Error) {
        switch error {
        case let decodingError as DecodingError:
            self = .decoding(decodingError)
        case let error as AppError:
            self = error
        default:
            self = .underlying(error)
        }
    }
}

extension AppError {
    var isNotFoundEntity: Bool {
        if case .database(let suberror) = self, case .notFound = suberror {
            return true
        }
        return false
    }
}
