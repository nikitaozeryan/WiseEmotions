//
//  Network+Response.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Network {
    enum ProgressResponse {
        case progress(Progress)
        case response(Response)
    }
    
    final class Response {
        let data: Data
        let response: HTTPURLResponse
        let request: URLRequest?
        let metrics: URLSessionTaskMetrics?

        var statusCode: Int {
            return response.statusCode
        }

        init(data: Data,
             response: HTTPURLResponse,
             request: URLRequest? = nil,
             metrics: URLSessionTaskMetrics? = nil) {
            self.data = data
            self.request = request
            self.response = response
            self.metrics = metrics
        }
    }
    
    final class SocketResponse: Decodable {
        let data: Data
        
        init(data: Data) {
            self.data = data
        }
    }
}

extension Network.Response {
    func decode<T: Decodable>(_ type: T.Type,
                              decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}

extension Network.SocketResponse {
    func decode<T: Decodable>(_ type: T.Type,
                              decoder: JSONDecoder = JSONDecoder()) throws -> T {
        try decoder.decode(T.self, from: data)
    }
}
