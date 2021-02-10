//
//  Network+Reactive.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import ReactiveSwift

extension Network: ReactiveExtensionsProvider {}

extension Reactive where Base == Network {
    func request(_ request: RequestConvertible,
                 qos: DispatchQoS.QoSClass = .default) -> AsyncTask<Network.Response> {
        return AsyncTask { [base] observer, lifetime in
            let progressCompletion: (Progress) -> Void = { _ in }
            let cancellable = base.request(request, qos: qos, progressCompletion: progressCompletion) { result in
                switch result {
                case .success(let response):
                    observer.send(value: response)
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: AppError(error))
                }
            }
            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }
    
    func progressRequest(_ request: RequestConvertible, qos: DispatchQoS.QoSClass = .default) -> AsyncTask<Network.ProgressResponse> {
        return AsyncTask { [base] observer, lifetime in
            let progressCompletion: (Progress) -> Void = { progress in
                observer.send(value: .progress(progress))
            }
            
            let cancellable = base.request(request, qos: qos, progressCompletion: progressCompletion) { result in
                switch result {
                case .success(let response):
                    observer.send(value: .response(response))
                    observer.sendCompleted()
                case .failure(let error):
                    observer.send(error: AppError(error))
                }
            }
            lifetime.observeEnded {
                cancellable.cancel()
            }
        }
    }
}
