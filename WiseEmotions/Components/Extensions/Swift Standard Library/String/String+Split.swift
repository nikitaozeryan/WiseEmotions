//
//  String+Split.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension String {
    /**
     Returns **maxSplits** number of substrings
     with lengths that are less than **maxLength** when encoded in UTF-8
     ```
     let string = "Hello, world!"
     string.split(maxLength: 3, maxSplits: 4) // ["Hel", "lo,", " wo", "rld"]
     
     ```
     */
    func split(maxLength length: Int, maxSplits: Int) -> [Substring] {
        var strings: [Substring] = []
        var currentIndex = startIndex
        repeat {
            let currentString = self[currentIndex ..< endIndex]
            var bytes: Int = 0
            let substring = currentString.prefix(while: {
                bytes += String($0).utf8.count
                return bytes <= length
            })
            strings.append(substring)
            currentIndex = substring.endIndex
        } while strings.count < maxSplits && currentIndex != endIndex
        return strings
    }
}
