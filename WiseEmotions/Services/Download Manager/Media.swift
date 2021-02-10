//
//  Media.swift
//  DownloadManager
//
//  Created by Nikita Ozerian on 5/16/20.
//  Copyright © 2020 Nikita Ozerian. All rights reserved.
//

import UIKit

public final class Media {

    public enum Status: Equatable {
        case unknown
        case failed(error: Error)
        case downloading(progress: Double)
        case cancelled
        case completed

        var canStart: Bool {
            switch self {
            case .unknown, .cancelled:
                return true

            case .failed, .downloading, .completed:
                return false
            }
        }

        var canCancel: Bool {
            switch self {
            case .downloading:
                return true

            case .unknown, .failed, .cancelled, .completed:
                return false
            }
        }
        
        
            public static func == (lhs: Media.Status, rhs: Media.Status) -> Bool {
                switch (lhs, rhs) {
                case (unknown, unknown),
                     (failed, failed),
                     (downloading, downloading),
                     (cancelled, cancelled),
                     (completed, completed):
                    return true
                default:
                    return false
                }
            }
    }

    let url: URL
    let ownerID: Int64
    var image: UIImage?

    var status: Status {
        didSet {
            notifyObservers(about: status)
        }
    }

    // MARK: - Lifecycle

    init(url: URL, ownerID: Int64) {
        self.url = url
        self.status = .unknown
        self.ownerID = ownerID
    }
}

// MARK: - Hashable Implementation

extension Media: Hashable {

    public static func == (lhs: Media, rhs: Media) -> Bool {
        lhs.url == rhs.url
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}


