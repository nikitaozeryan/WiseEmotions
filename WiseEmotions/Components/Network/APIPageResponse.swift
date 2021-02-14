//
//  APIResponse.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

struct APIPageResponse<Value> {
    let results: Value
    let count: Int?
}

extension APIPageResponse: Decodable where Value: Decodable {}
