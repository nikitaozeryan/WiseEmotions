//
//  PrimaryKeyProvider.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol PrimaryKeyProvider {
    static var primaryKey: String { get }
}
