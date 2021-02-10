//  
//  PokemonFactory.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import Foundation

protocol PokemonFactoryProtocol {
    func makePokemonVC(delegate: PokemonVMDelegate) -> PokemonVC
    func makePokemonDetailVC(with pokemon: Pokemon, delegate: PokemonDetailVMDelegate) -> PokemonDetailVC
}

final class PokemonFactory: ModuleFactory, PokemonFactoryProtocol {
    func makePokemonVC(delegate: PokemonVMDelegate) -> PokemonVC {
        makeController { $0.viewModel = PokemonVM(useCases: useCases, delegate: delegate) }
    }
    
    func makePokemonDetailVC(with pokemon: Pokemon, delegate: PokemonDetailVMDelegate) -> PokemonDetailVC {
        makeController { $0.viewModel = PokemonDetailVM(pokemon: pokemon, useCases: useCases, delegate: delegate) }
    }
}
