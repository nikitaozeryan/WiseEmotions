//
//  DownloadService.swift
//  DownloadManager
//
//  Created by Nikita Ozerian on 5/16/20.
//  Copyright © 2020 Nikita Ozerian. All rights reserved.
//

import UIKit

final class DownloadService: DownloadUseCase {
    
    // MARK: - Properties
    
    private(set) var downloads: [Media] = []
    
    // MARK: - Private properties
    
    private let operationQueue: OperationQueue
    private let imageCache: NSCache<NSString, UIImage>
    
    // MARK: - Public Interactions
    
    @discardableResult
    func addDownload(from url: URL, ownerID: Int64) -> Media? {
        
        let retVal = Media(url: url, ownerID: ownerID)
        if let media = downloads.first(where: { $0 == retVal }) {
            if case .downloading = media.status {
                return media
            } else if media.status == .completed {
                return media
            } else {
                self.startDownload(for: retVal)
                return media
            }
        } else {
            downloads.append(retVal)
            self.startDownload(for: retVal)
            return retVal
        }
    }
    
    @discardableResult
    func startDownload(for media: Media) -> Bool {
        guard media.status.canStart else { return false }
        
        guard let cachedImage = imageCache.object(forKey: media.url.absoluteString as NSString) else {
            let operation = DownloadingOperation(media: media, cache: imageCache)
            DispatchQueue.main.async {
                self.operationQueue.addOperation(operation)
            }
            
            return true
        }
        media.image = cachedImage
        media.status = .completed
        
        return false
    }
    
    @discardableResult
    func cancelDownload(for media: Media) -> Bool {
        
        guard media.status.canCancel else { return false }
        
        operationQueue.operations
            .compactMap { $0 as? DownloadingOperation }
            .filter { $0.media == media }
            .forEach { $0.cancel() }
        
        return true
    }
    
    // MARK: - Lifecycle
    
    init(imageCache: NSCache<NSString, UIImage>) {
        operationQueue = OperationQueue()
        operationQueue.maxConcurrentOperationCount = 3
        self.imageCache = imageCache
    }
}
