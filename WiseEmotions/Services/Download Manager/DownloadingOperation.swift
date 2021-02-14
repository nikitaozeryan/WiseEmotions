//
//  DownloadingOperation.swift
//  DownloadManager
//
//  Created by Nikita Ozerian on 5/16/20.
//  Copyright © 2020 Nikita Ozerian. All rights reserved.
//

import UIKit


final class DownloadingOperation: Operation {

    // MARK: - Properties
    
    var media: Media
    
    // MARK: - Private Properties
    
    private var task: UIBackgroundTaskIdentifier?
    private let cache: NSCache<NSString, UIImage>

    // MARK: - Lifecycle
    
    init(media: Media, cache: NSCache<NSString, UIImage>) {
        self.media = media
        self.cache = cache
    }

    override func start() {
        super.start()
        
        media.status = .downloading(progress: 0)

        task = beginBackgroundTask()
        
        URLSession.shared.dataTask(with: media.url) { data, response, error in
            self.task.flatMap { self.endBackgroundTask(taskID: $0) }
            if let error = error {
                self.media.status = .failed(error: error)
                return
            } else if
                let data = data,
                let image = UIImage(data: data) {
                self.media.image = image
                self.cache.setObject(image, forKey: self.media.url.absoluteString as NSString)
            }
            
            self.media.status = .completed
        }.resume()
    }

    override func cancel() {

        super.cancel()

        media.status = .cancelled
        task.flatMap { self.endBackgroundTask(taskID: $0)}
    }
    
    // MARK: - Helper methods
    
    private func beginBackgroundTask() -> UIBackgroundTaskIdentifier {
        return UIApplication.shared.beginBackgroundTask(expirationHandler: {})
    }

    private func endBackgroundTask(taskID: UIBackgroundTaskIdentifier) {
        UIApplication.shared.endBackgroundTask(taskID)
    }
}
