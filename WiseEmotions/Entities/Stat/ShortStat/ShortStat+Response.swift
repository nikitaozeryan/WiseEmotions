//
//  ShortStat+Response.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import Foundation

extension ShortStat {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case value = "base_stat"
            case effort
            case stat = "stat"
        }
        
        enum StatKodingKeys: String, CodingKey {
            case link = "url"
        }
        
        let value: Int64
        let effort: Int64
        let link: String
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let statContainer = try container.nestedContainer(keyedBy: StatKodingKeys.self, forKey: .stat)
            value = try container.decodeIfPresent(Int64.self, forKey: .value) ?? 0
            effort = try container.decodeIfPresent(Int64.self, forKey: .effort) ?? 0
            link = try statContainer.decode(String.self, forKey: .link)
        }
    }

    init(from response: Response, pokemonID: Int64) {
        value = response.value
        effort = response.effort
        link = response.link
        id = configureID(from: pokemonID, string: link)
    }
}
