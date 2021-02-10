//
//  Dictionary+Extension.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

extension Dictionary {
    /**
     Returns a new dictionary removing keys with nil values
     */
    func filterNilValues() -> Dictionary {
        return filter { _, value in
            if case nil = value as Any {
                return false
            } else {
                return true
            }
        }
    }
}

public extension Dictionary where Key == String, Value == Any {
    subscript(keyPath keyPath: String) -> Any? {
        get {
            let keys = Dictionary.makeKeys(from: keyPath)
            guard !keys.isEmpty else { return nil }
            return getValue(forKeys: keys)
        }
        set {
            let keys = Dictionary.makeKeys(from: keyPath)
            guard !keys.isEmpty, let newValue = newValue else { return }
            self.setValue(newValue, forKeys: keys)
        }
    }
    
    static private func makeKeys(from keyPath: String) -> [Key] {
        return keyPath.components(separatedBy: ".")
    }
    
    private func getValue(forKeys keys: [Key]) -> Any? {
        guard let firstKey = keys.first, let value = self[firstKey] else { return nil }
        return keys.count == 1
            ? value
            : (value as? Dictionary).flatMap { $0.getValue(forKeys: Array(keys.dropFirst())) }
    }
    
    private mutating func setValue(_ value: Any, forKeys keys: [Key]) {
        guard let firstKey = keys.first else { return }
        if keys.count == 1 {
            self[firstKey] = value
        } else {
            var innerDictionary = self[firstKey] as? Dictionary ?? [:]
            innerDictionary.setValue(value, forKeys: Array(keys.dropFirst()))
            self[firstKey] = innerDictionary
        }
    }
}
