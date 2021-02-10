//
//  Name.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

struct Name {
    let name: String
    let language: String
}

extension Name {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case language
            case name
        }
        enum NameCodingKeys: String, CodingKey, CaseIterable {
            case name
        }
        let name: String
        let language: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let languageContainer = try container.nestedContainer(keyedBy: NameCodingKeys.self, forKey: .language)
            name = try container.decode(String.self, forKey: .name)
            language = try languageContainer.decode(String.self, forKey: .name)
        }
    }
    
    init(from response: Response) {
        name = response.name
        language = response.language
    }
}
