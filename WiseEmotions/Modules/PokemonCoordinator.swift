//  
//  PokemonCoordinator.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift
import UIKit

final class PokemonCoordinator: Coordinator {
    
    // MARK: - Public Properties
    
    let useCases: UseCasesProvider
    
    // MARK: - Private properties
    
    private lazy var factory = PokemonFactory(coordinator: self)
    private weak var navigationController: UINavigationController!
    
    // MARK: - Life Cycle
    
    init(navigationController: UINavigationController,
         useCases: UseCasesProvider) {
        self.useCases = useCases
        self.navigationController = navigationController
    }
    
    func start(animated: Bool = true) {
        let pokemonVC = factory.makePokemonVC(delegate: self)
        navigationController.setViewControllers([pokemonVC], animated: animated)
    }
    
    func stop(animated: Bool = true) {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - PokemonVMDelegate

extension PokemonCoordinator: PokemonVMDelegate {
    func pokemonVM(_ viewModel: PokemonVM, didSelectPokemon pokemon: Pokemon) {
        let pokemonDetailVC = factory.makePokemonDetailVC(with: pokemon)
        if #available(iOS 13.0, *) {
            pokemonDetailVC.modalPresentationStyle = .automatic
            navigationController.present(BaseNavigationVC(rootViewController: pokemonDetailVC),
                                         animated: true)
        } else {
            navigationController.pushViewController(pokemonDetailVC,
                                                    animated: true)
        }
    }
}
