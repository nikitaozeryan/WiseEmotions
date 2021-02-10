//
//  URLRequest+Encoding.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import Alamofire

extension URLRequest {
    func encoded(_ parameters: Encodable,
                 encoder: JSONEncoder = JSONEncoder()) throws -> URLRequest {
        do {
            var request = self
            let encodable = AnyEncodable(encodable: parameters)
            request.httpBody = try encoder.encode(encodable)
            let contentTypeHeaderName = "Content-Type"
            let contentType = request.value(forHTTPHeaderField: contentTypeHeaderName)
                ?? "application/json"
            request.setValue(contentType, forHTTPHeaderField: contentTypeHeaderName)
            return request
        } catch {
            throw NetworkError.parametersEncoding(error)
        }
    }

    func encoded(_ parameters: Alamofire.Parameters,
                 encoding: Alamofire.ParameterEncoding) throws -> URLRequest {
        do {
            return try encoding.encode(self, with: parameters)
        } catch {
            throw NetworkError.parametersEncoding(error)
        }
    }

    func encoded(for target: RequestConvertible) throws -> URLRequest {
        switch target.task {
        case .requestData(let body):
            return with(self) { $0.httpBody = body }
        case .requestJSONEncodable(let encodable):
            return try encoded(encodable)
        case .requestCustomJSONEncodable(let encodable, let encoder):
            return try encoded(encodable, encoder: encoder)
        case let .requestWithParameters(parameters, encoding):
            return try encoded(parameters.make(), encoding: encoding)
        case .requestCompositeData(let body, let urlParameters):
            return try with(self) { $0.httpBody = body }
                .encoded(urlParameters, encoding: URLEncoding.default)
        case .requestCompositeParameters(let bodyParameters,
                                         let bodyEncoding,
                                         let urlParameters):
            return try encoded(bodyParameters, encoding: bodyEncoding)
                .encoded(urlParameters, encoding: URLEncoding.default)
        case .uploadCompositeMultipart(let urlParameters, _):
            return try encoded(urlParameters, encoding: URLEncoding.default)
        case .downloadParameters(let parameters, let encoding, _),
             .requestParameters(let parameters, let encoding):
            return try encoded(parameters, encoding: encoding)
        default:
            return self
        }
    }
}
