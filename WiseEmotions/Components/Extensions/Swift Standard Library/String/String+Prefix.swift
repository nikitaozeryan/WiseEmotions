//
//  String+Prefix.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension String {
    /**
     Returns a substring containing the initial elements
     until its length is less than **maxUTF8Length** when encoded it UTF-8
     ```
     let string = "Hello, world!"
     string.split(maxLength: 200, maxSplits: 10, using: .utf8)
     ```
     */
    func prefix(maxUTF8Length length: Int) -> Substring {
        var currentLength = 0
        return prefix(while: {
            currentLength += String($0).utf8.count
            return currentLength <= length
        })
    }
}
