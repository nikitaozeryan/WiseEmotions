//
//  Network+Headers.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Network.Header {
    static func accept(contentTypes: [String]) -> Network.Header {
        return Network.Header(name: "Accept", value: contentTypes.joined(separator: ", "))
    }
    
    static var defaultAccept: Network.Header {
        return accept(contentTypes: ["application/json"])
    }
}
