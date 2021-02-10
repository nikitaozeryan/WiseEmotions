//
//  API+Pokemons.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation
import Alamofire

extension API {
    enum Pokemons: RequestConvertible {
        case fetch(limitOffset: LimitOffset)
        case fetchPokemon(url: URL)

        var path: String {
            switch self {
            case .fetch:
                return "/pokemon"
            default:
                return ""
            }
        }
        
        var method: Network.Method {
            .get
        }
        
        var task: Network.Task {
            switch self {
            case .fetch(let limitOffset):
                return .requestParameters(parameters: limitOffset.builder.make(), encoding: URLEncoding.queryString)
            default:
                return .requestPlain
            }
        }
        
        var baseURL: URL? {
            switch self {
            case .fetchPokemon(let url):
                return url
            default:
                return nil
            }
        }
    }
}

