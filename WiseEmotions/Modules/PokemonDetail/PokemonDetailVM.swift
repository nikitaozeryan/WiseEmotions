//  
//  PokemonDetailVM.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import ReactiveSwift

final class PokemonDetailVM: UseCasesConsumer {
    typealias UseCases = HasPokemonUseCase & HasDownloadUseCase

    // MARK: - Public Properties
    
    private(set) var pokemon: Pokemon
    private(set) var sortedTypes: [Type]
    
    // MARK: - Life Cycle
    
    init(pokemon: Pokemon, useCases: UseCases) {
        self.pokemon = pokemon
        self.sortedTypes = pokemon.types.sorted(by: { $0.slot < $1.slot })
        self.useCases = useCases
    }
}

