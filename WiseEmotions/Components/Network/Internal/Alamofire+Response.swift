//
//  Alamofire+Response.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import Alamofire

extension Network.Response {
    convenience init(_ dataResponse: DataResponse<Data, Error>) throws {
        try self.init(dataResponse.result,
                      dataResponse.response,
                      dataResponse.request,
                      dataResponse.metrics)
    }

    convenience init(_ dataResponse: DownloadResponse<Data, Error>) throws {
        try self.init(dataResponse.result,
                      dataResponse.response,
                      dataResponse.request,
                      dataResponse.metrics)
    }

    convenience init(_ result: Result<Data, Error>,
                     _ response: HTTPURLResponse?,
                     _ request: URLRequest?,
                     _ metrics: URLSessionTaskMetrics?) throws {
        switch result {
        case .success(let data):
            guard let response = response else {
                throw NetworkError.missingResponse
            }
            self.init(data: data,
                      response: response,
                      request: request,
                      metrics: metrics)
        case .failure(let error):
            throw error
        }
    }
}
