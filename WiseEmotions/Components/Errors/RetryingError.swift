//
//  RetryingError.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Alamofire
import Foundation

enum RetryingError: Int, LocalizedError, CaseIterable {
    case other
    case timedOut = -1001
    case tnknown = -1
    case lostInternetConnection = -1009
    case secureConnectionFailed = -1200
    case cannotConnectToHost = -1004
    case cannotFindHost = -1003
    case cannotLoadFromNetwork = -2000
    case dataNotAllowed = -1020
    case networkConnectionLost = -1005
}

// MARK: - AFError

extension AFError {
    var retryingError: RetryingError? {
        switch self {
        case .sessionTaskFailed(error: let thisError):
            let domainError = thisError as NSError
            let retringError = RetryingError(rawValue: domainError.code)
            return retringError
        default: return nil
        }
    }
}
