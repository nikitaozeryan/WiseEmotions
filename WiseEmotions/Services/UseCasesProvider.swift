//
//  UseCasesProvider.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

internal protocol HasPokemonUseCase {
    var pokemon: PokemonUseCase { get }
}

internal protocol HasInformationUseCase {
    var information: InformationUseCase { get }
}

internal protocol HasDownloadUseCase {
    var download: DownloadUseCase { get }
}

typealias UseCases = HasPokemonUseCase
    & HasInformationUseCase
    & HasDownloadUseCase

protocol UseCasesProvider: UseCases {}

