//
//  LocalIdProvider.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol LocalIdProvider {
    static var localKey: String { get }
}
