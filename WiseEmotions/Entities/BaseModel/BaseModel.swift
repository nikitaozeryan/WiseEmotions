//
//  BaseModel.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import Foundation

struct BaseModel {
    let name: String
    let url: URL
}

extension BaseModel {
    struct Response: Decodable {
        let name: String
        let url: String
    }
    
    init?(from response: Response) {
        guard let url = URL(string: response.url) else { return nil }
        name = response.name
        self.url = url
    }
}
