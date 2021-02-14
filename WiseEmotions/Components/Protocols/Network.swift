//
//  Network.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 14.02.2021.
//

import ReactiveSwift
import Foundation

protocol Network {
    func request<T: Decodable>(with request: URLRequest, objectType: T.Type) -> AsyncTask<T>
}
