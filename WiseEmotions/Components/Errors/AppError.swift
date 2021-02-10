//
//  AppError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Alamofire
import Foundation

enum Permission {
    case location(always: Bool)
    case notifications
    case gallery
    case camera
    case microphone
    case contacts
}

enum AppError: Error {
    enum Database {
        case notFound
    }
    
    case alamofire(AFError)
    case database(Database)
    case underlying(Error)
    case api(APIError)
    case decoding(DecodingError)
    case sessionRequired
    case logic(String)
    case unknown
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .alamofire(let error):
            guard let underlyingError = error.underlyingError else { return error.localizedDescription }
            return underlyingError.localizedDescription
        case .underlying(let error):
            return error.localizedDescription
        case .api(let error):
            return error.localizedDescription
        case .decoding(let error):
            return error.debugDescription
        case .sessionRequired:
            return "Session is required"
        case .unknown:
            return "Something went wrong. Try again later"
        case let .logic(description):
            return description
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
        case let afError as AFError:
            self = .alamofire(afError)
        case let apiError as APIError:
            self = .api(apiError)
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
