//
//  API+Information.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import Foundation
import Alamofire

extension API {
    enum Information: RequestConvertible {
        case fetchStats(limitOffset: LimitOffset)
        case fetchTypes(limitOffset: LimitOffset)
        case fetchStat(url: URL)
        case fetchType(url: URL)

        var path: String {
            switch self {
            case .fetchStats:
                return "/stat"
            case .fetchTypes:
                return "/type"
            default:
                return ""
            }
        }
        
        var method: Network.Method {
            .get
        }
        
        var task: Network.Task {
            switch self {
            case .fetchStats(let limitOffset), .fetchTypes(let limitOffset):
                return .requestParameters(parameters: limitOffset.builder.make(), encoding: URLEncoding.queryString)
            default:
                return .requestPlain
            }
        }
        
        var baseURL: URL? {
            switch self {
            case .fetchType(let url), .fetchStat(let url):
                return url
            default:
                return nil
            }
        }
    }
}
