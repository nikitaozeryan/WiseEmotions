//
//  APIError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

public struct APIError: Decodable, LocalizedError {
    public let code: String
    public let errors: [InnerError]
    public let httpCode: Int

    public var errorDescription: String? {
        return errors.first?.message
    }
    
    var status: Status {
        switch httpCode {
        case 401:
            return .unauthorized
        case 402:
            return .paymentRequired
        case 403:
            return .forbidden
        case 404:
            return .notFound
        case 405:
            return .methodNotAllowed
        case 406:
            return .notAcceptable
        case 408:
            return .requestTimeout
        case 422:
            return .unprocessable
        case 500..<600:
            return .serverError
        default:
            return .other
        }
    }
}

extension APIError {
    public struct InnerError: Decodable, LocalizedError {
        public let key: String
        public let message: String
        public let email: String?
        
        public var errorDescription: String {
            return message
        }
    }
    
    public init(_ response: Response, httpCode: Int) {
        self.code = response.code
        self.errors = response.errors
        self.httpCode = httpCode
    }
}

extension APIError {
    public struct Response: Decodable {
        public let code: String
        public let errors: [InnerError]
    }
}

extension Error {
    var apiError: APIError? {
        if let apiError = self as? APIError {
            return apiError
        } else if let appError = self as? AppError, case .api(let apiError) = appError {
            return apiError
        } else {
            return nil
        }
    }
}
