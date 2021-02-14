//
//  Pokemon+Response.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Pokemon {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case id
            case name
            case sprites
            case stats
            case types
        }
        enum SpritesCodingKeys: String, CodingKey, CaseIterable {
            case frontDefault = "front_default"
            case `default` = "back_default"
            case backFemale = "back_female"
            case backShiny = "back_shiny"
            case backShinyFemale = "back_shiny_female"
            case frontShiny = "front_shiny"
            case frontFemale = "front_female"
            case frontShinyFemale = "front_shiny_female"
        }
        let id: Int64
        let name: String
        let imageURL: String?
        let imageURLs: [String]
        let stats: [ShortStat.Response]
        let types: [ShortType.Response]
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let spritesContainer = try container.nestedContainer(keyedBy: SpritesCodingKeys.self, forKey: .sprites)
            id = try container.decode(Int64.self, forKey: .id)
            name = try container.decode(String.self, forKey: .name)
            imageURLs = try SpritesCodingKeys.allCases.map {
                try spritesContainer.decodeIfPresent(String.self, forKey: $0)
            }.compactMap { $0 }
            imageURL = imageURLs.first
            stats = try container.decodeIfPresent([ShortStat.Response].self, forKey: .stats) ?? []
            types = try container.decodeIfPresent([ShortType.Response].self, forKey: .types) ?? []
        }
    }
    
    init(from response: Response) {
        id = response.id
        name = response.name
        imageURL = response.imageURL.flatMap { URL(string: $0) }
        imageURLS = response.imageURLs.compactMap { URL(string: $0) }
        shortTypes = response.types.map { ShortType(from: $0, pokemonID: response.id) }
        shortStats = response.stats.map { ShortStat(from: $0, pokemonID: response.id) }
        types = []
        stats = []
    }
}
