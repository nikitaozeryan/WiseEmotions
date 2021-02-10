//
//  Coordinator.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol Coordinator: class {
    var useCases: UseCasesProvider { get }
    
    func start(animated: Bool)
    func stop(animated: Bool)
}
