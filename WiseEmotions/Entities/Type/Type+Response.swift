//
//  Type+Response.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

extension Type {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case name
            case names
        }
        let name: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let names = try container.decode([Name.Response].self, forKey: .names)
            if let localizedName = names.first(where: { $0.language == defaultLanguage }) {
                name = localizedName.name
            } else {
                name = try container.decode(String.self, forKey: .name)
            }
        }
    }
    
    init(from response: Response, shortType: ShortType, pokemonID: Int64) {
        id = configureID(from: pokemonID, string: shortType.link)
        name = response.name
        slot = shortType.slot
        link = shortType.link
    }
}
