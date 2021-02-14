//
//  LimitOffsetParams.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

struct LimitOffset {
    static let defaultLimit = 20

    enum CodingKeys: String, CodingKey {
        case offset
        case limit
        case total
    }
    
    // MARK: - Properties

    var offset: Int
    let limit: Int
    let total: Int?
    
    var hasMore: Bool { total.flatMap { $0 > offset } ?? true }
    var isFirstPage: Bool { offset == 0 }
    var parameters: [String: String] { [CodingKeys.offset.stringValue: "\(offset)", CodingKeys.limit.stringValue: "\(limit)"] }
    
    // MARK: - Lifecycle

    init(offset: Int = 0, limit: Int = defaultLimit, total: Int? = nil) {
        self.offset = offset
        self.limit = limit
        self.total = total
    }
    
    init(_ response: Response) {
        self.init(offset: response.nextOffset, total: response.total)
    }
    
    init(_ response: Response, limit: Int? = nil) {
        self.init(offset: response.nextOffset, limit: limit ?? LimitOffset.defaultLimit)
    }
    
    // MARK: - Helper Methods
    
    mutating func nextPage() -> LimitOffset? {
        guard hasMore else { return nil }
        offset += limit
        return self
    }
    
    @discardableResult
    mutating func reset() -> LimitOffset {
        self = LimitOffset(offset: 0, limit: limit)
        return self
    }
    
    @discardableResult
    mutating func reset(with limit: Int) -> LimitOffset {
        self = LimitOffset(offset: 0, limit: limit)
        return self
    }
}

extension LimitOffset {
    struct Response: Decodable {
        enum CodingKeys: String, CodingKey {
            case total = "totalCount"
            case nextOffset
        }

        let total: Int
        let nextOffset: Int

        var hasMore: Bool {
            return total > nextOffset
        }
    }
}
