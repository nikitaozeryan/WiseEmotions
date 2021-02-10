//
//  ShortType+Response.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

extension ShortType {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case slot
            case type
        }
        
        enum TypeKodingKeys: String, CodingKey {
            case link = "url"
        }
        
        let slot: Int64
        let link: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let typeContainer = try container.nestedContainer(keyedBy: TypeKodingKeys.self, forKey: .type)
            slot = try container.decodeIfPresent(Int64.self, forKey: .slot) ?? 0
            link = try typeContainer.decode(String.self, forKey: .link)
        }
    }

    init(from response: Response, pokemonID: Int64) {
        slot = response.slot
        link = response.link
        id = configureID(from: pokemonID, string: link)
    }
}
