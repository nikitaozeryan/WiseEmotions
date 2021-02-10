//
//  OrderedSet.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

public struct OrderedSet<T>: RandomAccessCollection {
    public typealias Index = Array<T>.Index
    public typealias Element = Array<T>.Element
    public typealias Hash = Int
    
    private var objects: [T] = []
    private let hashBuilder: (T) -> Int
    private var indexOfHash: [Hash: Index] = [:]
    
    public init(_ hashBuilder: @escaping (T) -> Hash) {
        self.hashBuilder = hashBuilder
    }
    
    // O(1)
    public mutating func append(_ object: T) {
        guard !contains(object) else { return }
        
        objects.append(object)
        indexOfHash[hashBuilder(object)] = index(before: endIndex)
    }
    
    // O(n)
    public mutating func insert(_ object: T, at index: Int) {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")
        
        guard !contains(object) else { return }
        
        objects.insert(object, at: index)
        indexOfHash[hashBuilder(object)] = index
        for tempIndex in index + 1..<objects.count {
            indexOfHash[hashBuilder(objects[tempIndex])] = tempIndex
        }
    }
    
    // O(1)
    public func object(at index: Int) -> T {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")
        
        return objects[index]
    }
    
    // O(1)
    public mutating func set(_ object: T, at index: Int) {
        assert(index < objects.count, "Index should be smaller than object count")
        assert(index >= 0, "Index should be bigger than 0")
        
        guard indexOfHash[hashBuilder(object)] == nil else {
            return
        }
        
        indexOfHash.removeValue(forKey: hashBuilder(objects[index]))
        indexOfHash[hashBuilder(object)] = index
        objects[index] = object
    }
    
    // O(1)
    public func index(of object: T) -> Index? {
        return indexOfHash[hashBuilder(object)]
    }
    
    // O(1)
    public func contains(_ object: T) -> Bool {
        return index(of: object) != nil
    }
    
    // O(n)
    public mutating func remove(_ object: T) -> T? {
        guard let index = index(of: object) else { return nil }
        
        indexOfHash.removeValue(forKey: hashBuilder(object))
        let removedObject = objects.remove(at: index)
        for tempIndex in index..<objects.count {
            indexOfHash[hashBuilder(objects[tempIndex])] = tempIndex
        }
        return removedObject
    }
    
    public var values: [T] {
        return objects
    }
    
    // MARK: - Collection
    
    // The upper and lower bounds of the collection, used in iterations
    public var startIndex: Index { return objects.startIndex }
    public var endIndex: Index { return objects.endIndex }
    
    // Required subscript, based on a dictionary index
    public subscript(index: Index) -> Iterator.Element {
        return objects[index]
    }
    
    // Method that returns the next index when iterating
    public func index(after afterIndex: Index) -> Index {
        return objects.index(after: afterIndex)
    }
    
    public func index(before beforeIndex: Index) -> Index {
        return objects.index(before: beforeIndex)
    }
}

extension OrderedSet where T: Hashable {
    public init() {
        self.init { $0.hashValue }
    }
}

extension OrderedSet where T: Identifiable {
    public init() {
        self.init { $0.id.hashValue }
    }
}
