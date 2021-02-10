//  
//  PokemonUseCase.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift
import CoreData

typealias PokemonsPage = (pokemons: [Pokemon], pagination: LimitOffset)

protocol PokemonUseCase {
    var setupProducer: SignalProducer<CoreDataStack, AppError> { get }
    
    func fetchPokemonList(with limitOffset: LimitOffset) -> AsyncTask<PokemonsPage>
    func fetchInfo(from pokemon: Pokemon) -> AsyncTask<Pokemon>
    func pokemonsFetchRequest() -> NSFetchRequest<PokemonEntity>
}

