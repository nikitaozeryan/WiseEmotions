//
//  DefaultNetworkStrategy.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

class APIErrorPlugin: NetworkPlugin {
    func process(_ result: Network.ResponseResult,
                 target: RequestConvertible) -> Network.ResponseResult {
        guard case .success(let response) = result,
            400 ..< 600 ~= response.statusCode else {
                guard case .failure(let error) = result else { return result }
                guard let afError = error.asAFError else { return result }
                return .failure(AppError.alamofire(afError))
        }
        if let serverError = HTTPServerError(statusCode: response.statusCode) {
            return .failure(serverError)
        }
        
        do {
            let responseError = try response.decode(APIError.Response.self)
            let apiError = APIError(responseError, httpCode: response.statusCode)
            return .failure(apiError)
        } catch {
            return .failure(error)
        }
    }
}
