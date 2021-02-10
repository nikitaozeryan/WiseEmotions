//
//  RequestConvertible.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol RequestConvertible {
    /// Base URL for request, takes precedence over `baseURL` in `Network` if specified.
    var baseURL: URL? { get }

    /// The path to be appended to `baseURL` to form the full `URL`.
    var path: String { get }

    /// The HTTP method used in the request.
    var method: Network.Method { get }

    /// The type of HTTP task to be performed.
    var task: Network.Task { get }

    /// The headers to be used in the request.
    var headers: Network.Headers? { get }

    /// Should request be considered for retry
    var retryEnabled: Bool { get }
}

extension RequestConvertible {
    var baseURL: URL? { return nil }

    var headers: Network.Headers? { return nil }

    var retryEnabled: Bool { return true }
}
