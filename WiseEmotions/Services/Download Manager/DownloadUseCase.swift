//
//  DownloadUseCase.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import Foundation

protocol DownloadUseCase {
    @discardableResult
    func addDownload(from url: URL, ownerID: Int64) -> Media?
    
    @discardableResult
    func startDownload(for media: Media) -> Bool
    
    @discardableResult
    func cancelDownload(for media: Media) -> Bool
}
