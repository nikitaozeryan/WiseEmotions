//
//  Network.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import Alamofire

final class Network {
    typealias ResponseResult = Result<Response, Error>
    typealias RetryResult = Alamofire.RetryResult
    typealias Request = Alamofire.Request
    typealias Completion = (ResponseResult) -> Void
    typealias DownloadDestination = DownloadRequest.Destination
    typealias Method = Alamofire.HTTPMethod
    typealias MultipartFormDataBuilder = (MultipartFormData) -> Void
    typealias Header = HTTPHeader
    typealias Headers = HTTPHeaders
    
    class var defaultHeaders: Headers {
        return with(.default) { $0.add(.defaultAccept) }
    }
    
    private let session: Alamofire.Session
    private let baseURL: URL
    private let plugins: [NetworkPlugin]
    
    // MARK: - Public
    
    init(baseURL: URL,
         plugins: [NetworkPlugin] = [],
         commonHeaders: Headers = defaultHeaders) {
        self.baseURL = baseURL
        self.plugins = plugins
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.headers = commonHeaders
        session = Alamofire.Session(configuration: configuration, startRequestsImmediately: false)
    }
    
    func request(_ target: RequestConvertible,
                 qos: DispatchQoS.QoSClass = .default,
                 progressCompletion: @escaping (Progress) -> Void,
                 completion: @escaping Completion) -> Cancellable {
        return performRequest(CachedRequestConvertible(target),
                              queue: .global(qos: qos),
                              progressCompletion: progressCompletion,
                              completion: completion)
    }
    
    // MARK: - Private
    // swiftlint:disable function_body_length
    private func performRequest(_ target: RequestConvertible,
                                queue: DispatchQueue,
                                progressCompletion: @escaping (Progress) -> Void,
                                completion: @escaping Completion) -> Cancellable {
        let token = CancellableToken()
        let commonCompletion: Completion = { [weak self] result in
            guard let self = self else { return }
            self.didReceive(result, target: target)
            let result = self.process(result, target: target)
            self.handleResult(result,
                              target: target,
                              queue: queue,
                              token: token,
                              progressCompletion: progressCompletion,
                              completion: completion)
        }
        
        do {
            let urlRequest = try makeURLRequest(for: target)
            switch target.task {
            case .downloadDestination(let destination), .downloadParameters(_, _, let destination):
                return performDownload(urlRequest,
                                       destination: destination,
                                       token: token,
                                       queue: queue,
                                       target: target,
                                       completion: commonCompletion)
            case .uploadFile(let fileURL):
                return performUpload(urlRequest,
                                     fileURL: fileURL,
                                     token: token,
                                     queue: queue,
                                     target: target,
                                     completion: commonCompletion)
            case .uploadMultipart(let builder), .uploadCompositeMultipart(_, let builder):
                return performUpload(urlRequest,
                                     builder: builder,
                                     token: token,
                                     queue: queue,
                                     target: target,
                                     progressCompletion: progressCompletion,
                                     completion: commonCompletion)
            default: return performData(urlRequest,
                                        token: token,
                                        queue: queue,
                                        target: target,
                                        progressCompletion: progressCompletion,
                                        completion: commonCompletion)
            }
        } catch {
            queue.async {
                guard !token.isCancelled else { return }
                commonCompletion(.failure(error))
            }
            return token
        }
    }
    // swiftlint:enable function_body_length
    
    // MARK: - Data request
    
    private func performData(_ request: URLRequest,
                             token: CancellableToken,
                             queue: DispatchQueue,
                             target: RequestConvertible,
                             progressCompletion: @escaping (Progress) -> Void,
                             completion: @escaping Completion) -> Cancellable {
        let task = session
            .request(request)
            .responseData(queue: queue) { responseData in
                guard !token.isCancelled else { return }
                guard let response = responseData.response else {
                    return completion(.failure(responseData.error ?? AppError.unknown))
                }
                completion(Result { Response(data: responseData.data ?? Data(), response: response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    // MARK: - Download request
    
    private func performDownload(_ request: URLRequest,
                                 destination: DownloadDestination?,
                                 token: CancellableToken,
                                 queue: DispatchQueue,
                                 target: RequestConvertible,
                                 completion: @escaping Completion) -> Cancellable {
        let task = session
            .download(request, to: destination)
            .responseData(queue: queue) { responseData in
                guard !token.isCancelled else { return }
                guard let data = responseData.value, let response = responseData.response else {
                    return completion(.failure(responseData.error ?? AppError.unknown))
                }
                completion(Result { Response(data: data, response: response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    // MARK: - Upload request
    
    private func performUpload(_ request: URLRequest,
                               fileURL: URL,
                               token: CancellableToken,
                               queue: DispatchQueue,
                               target: RequestConvertible,
                               completion: @escaping Completion) -> Cancellable {
        let task = session
            .upload(fileURL, with: request)
            .responseData(queue: queue) { responseData in
                guard !token.isCancelled else { return }
                guard let data = responseData.data, let response = responseData.response else {
                    return completion(.failure(responseData.error ?? AppError.unknown))
                }
                completion(Result { Response(data: data, response: response) })
        }
        token.didCancel {
            task.cancel()
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    private func performUpload(_ request: URLRequest,
                               builder: MultipartFormDataBuilder,
                               token: CancellableToken,
                               queue: DispatchQueue,
                               target: RequestConvertible,
                               progressCompletion: @escaping (Progress) -> Void,
                               completion: @escaping Completion) -> Cancellable {
        let formData = MultipartFormData()
        builder(formData)
        
        let task = session
            .upload(multipartFormData: formData, with: request)
            .responseData(queue: queue) { responseData in
                guard !token.isCancelled else { return }
                guard let data = responseData.data, let response = responseData.response else {
                    return completion(.failure(responseData.error ?? AppError.unknown))
                }
                completion(Result { Response(data: data, response: response) })
        }
        token.didCancel {
            task.cancel()
        }
        task.uploadProgress { progress in
            progressCompletion(progress)
        }
        willSend(task, target: target)
        task.resume()
        
        return token
    }
    
    // MARK: - URLRequest builder
    
    private func makeBaseURL(for target: RequestConvertible) throws -> URL {
        return target.baseURL ?? baseURL
    }
    
    private func makeURLRequest(for target: RequestConvertible) throws -> URLRequest {
        let url = try makeBaseURL(for: target).appendingPathComponent(target.path)
        var request = try URLRequest(url: url).encoded(for: target)
        request.httpMethod = target.method.rawValue
        target.headers?.dictionary.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        return try prepare(request, target: target)
    }
    
    // MARK: - Handle result
    
    private func handleResult(_ result: ResponseResult,
                              target: RequestConvertible,
                              queue: DispatchQueue,
                              token: CancellableToken,
                              progressCompletion: @escaping (Progress) -> Void,
                              completion: @escaping Completion) {
        guard case .failure(let error) = result else {
            completion(result)
            return
        }
        should(retry: target, dueTo: error, plugins: plugins) { [weak self] in
            guard let self = self else { return }
            switch $0 {
            case .doNotRetry:
                completion(result)
            case .doNotRetryWithError(let newError):
                completion(.failure(newError))
            case .retry:
                let innerToken = self.performRequest(target,
                                                     queue: queue,
                                                     progressCompletion: progressCompletion,
                                                     completion: completion)
                token.didCancel {
                    innerToken.cancel()
                }
            case .retryWithDelay(let interval):
                queue.asyncAfter(deadline: .now() + interval) { [weak self] in
                    guard !token.isCancelled, let self = self else { return }
                    let innerToken = self.performRequest(target,
                                                         queue: queue,
                                                         progressCompletion: progressCompletion,
                                                         completion: completion)
                    token.didCancel {
                        innerToken.cancel()
                    }
                }
            }
        }
    }
}

// MARK: - Handle NetworkPlugin methods

extension Network {
    private func prepare(_ request: URLRequest,
                         target: RequestConvertible) throws -> URLRequest {
        return try plugins.reduce(request) { try $1.prepare($0, target: target) }
    }
    
    private func willSend(_ request: Network.Request, target: RequestConvertible) {
        plugins.forEach { $0.willSend(request, target: target) }
    }
    
    private func didReceive(_ result: Network.ResponseResult,
                            target: RequestConvertible) {
        plugins.forEach { $0.didReceive(result, target: target) }
    }
    
    private func process(_ result: Network.ResponseResult,
                         target: RequestConvertible) -> Network.ResponseResult {
        return plugins.reduce(result) { $1.process($0, target: target) }
    }
}

// MARK: - Handle RequestRetrier methods

extension Network {
    private func should(retry target: RequestConvertible,
                        dueTo error: Error,
                        plugins: [NetworkPlugin],
                        completion: @escaping (RetryResult) -> Void) {
        guard target.retryEnabled, let plugin = plugins.first else {
            completion(.doNotRetry)
            return
        }
        plugin.should(retry: target, dueTo: error) { [weak self] result in
            guard let self = self else { return }
            if case .doNotRetry = result {
                self.should(retry: target,
                            dueTo: error,
                            plugins: Array(plugins.dropFirst()),
                            completion: completion)
            } else {
                completion(result)
            }
        }
    }
}
