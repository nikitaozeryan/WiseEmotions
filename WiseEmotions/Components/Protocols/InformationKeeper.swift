//
//  InformationKeeper.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol InformationKeeper {
    associatedtype Info: Codable

    func save(_ info: Info) throws
    func invalidate() throws
    func fetch() -> Info?
}
