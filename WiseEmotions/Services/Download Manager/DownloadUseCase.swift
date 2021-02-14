//
//  DownloadUseCase.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 08.02.2021.
//

import Foundation

protocol DownloadUseCase {
    @discardableResult
    func add(from url: URL, ownerID: Int64) -> Media?
    
    @discardableResult
    func start(for media: Media) -> Bool
    
    @discardableResult
    func cancel(for media: Media) -> Bool
}
