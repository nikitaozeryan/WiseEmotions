//  
//  PokemonVM.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift

protocol PokemonVMDelegate: AnyObject {
    func pokemonVM(_ viewModel: PokemonVM, didSelectPokemon pokemon: Pokemon)
}

final class PokemonVM: UseCasesConsumer {
    typealias UseCases = HasPokemonUseCase & HasDownloadUseCase
    private enum C {
        static let searchLimit: Int = 30
    }

    // MARK: - Public Properties
    
    let actions = ActionGroup()
    let pagination = MutableProperty(LimitOffset(limit: C.searchLimit))
    
    // MARK: - Private Properties
    
    private weak var delegate: PokemonVMDelegate?

    // MARK: - Actions
    
    private(set) lazy var fetchPokemonsAction = Action(execute: fetchPokemons)
    private(set) lazy var fetchPokemonInfo = Action(execute: useCases.pokemon.fetchInfo)
    
    // MARK: - Life Cycle
    
    init(useCases: UseCases, delegate: PokemonVMDelegate) {
        self.useCases = useCases
        self.delegate = delegate
        setupActionGroup()
        setupObservers()
    }
    
    // MARK: - Helper methods
    
    func selectPokemonEntity(_ pokemonEntity: PokemonEntity) {
        fetchPokemonInfo.apply(Pokemon(from: pokemonEntity)).start()
    }
    
    // MARK: - Private methods
    
    private func setupActionGroup() {
        actions.append(fetchPokemonsAction)
        actions.append(fetchPokemonInfo)
    }
    
    private func setupObservers() {
        pagination <~ fetchPokemonsAction.values.map { $0.pagination }
        
        fetchPokemonInfo
            .values
            .take(duringLifetimeOf: self)
            .observe(on: UIScheduler())
            .observeValues { [weak self] pokemon in
                guard let viewModel = self else { return }
                viewModel.delegate?.pokemonVM(viewModel, didSelectPokemon: pokemon)
            }
    }
    
    private func fetchPokemons(offset: Int) -> AsyncTask<PokemonsPage> {
        useCases.pokemon.fetchPokemonList(with: LimitOffset(offset: offset))
    }
}

