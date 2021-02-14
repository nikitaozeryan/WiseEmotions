//
//  NetworkURLSession.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 14.02.2021.
//

import Foundation
import ReactiveSwift

//public let bgSession = URLSession(configuration: URLSessionConfiguration.background(withIdentifier:
//                                                                                        "com.epam.WiseEmotions.bgSession"))

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

final class NetworkURLSession: Network {
    func request<T: Decodable>(with request: URLRequest, objectType: T.Type) -> AsyncTask<T> {
        AsyncTask { observer, lifetime in
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
                guard let data = data else {
                    guard let error = error else {
                        observer.send(error: .logic("Response data and error are nil"))
                        observer.sendCompleted()
                        return
                    }
                    observer.send(error: AppError(error))
                    observer.sendCompleted()
                    return
                }
                
                do {
                    let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                    observer.send(value: decodedObject)
                    observer.sendCompleted()
                } catch let error {
                    observer.send(error: AppError(error))
                    observer.sendCompleted()
                }
            })
            task.resume()
        }
    }
}

func request(by urlString: String, parameters: [String: String] = [:], httpMethod: HTTPMethod = .get) -> Result<URLRequest, AppError> {
    guard var components = URLComponents(string: baseURL.absoluteString + urlString) else {
        return .failure(.logic("Base URL with path \(urlString) is nil"))
    }
    
    components.queryItems = parameters.map {
        URLQueryItem(name: $0, value: $1)
    }
    
    guard let urlWithComponents = components.url else {
        return .failure(.logic("Base URL with path \(urlString) is nil"))
    }
    
    return .success(with(URLRequest(url: urlWithComponents)) {
        $0.httpMethod = httpMethod.rawValue
    })
}

func request(by url: URL, parameters: [String: String] = [:], httpMethod: HTTPMethod = .get) -> Result<URLRequest, AppError> {
    guard var components = URLComponents(string: url.absoluteString) else {
        return .failure(.logic("URL with path \(url.absoluteString) is nil"))
    }
    
    components.queryItems = parameters.map {
        URLQueryItem(name: $0, value: $1)
    }
    
    guard let urlWithComponents = components.url else {
        return .failure(.logic("URL with path \(url.absoluteString) is nil"))
    }
    
    return .success(with(URLRequest(url: urlWithComponents)) {
        $0.httpMethod = httpMethod.rawValue
    })
}
