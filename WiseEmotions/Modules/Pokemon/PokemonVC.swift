//  
//  PokemonVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift
import UIKit
import CoreData

extension PokemonVC: Makeable {
    static func make() -> PokemonVC {
        return PokemonVC()
    }
}

final class PokemonVC: BaseVC, ViewModelContainer {
    
    // MARK: - Properties
    
    private lazy var mainView: PokemonView = {
        PokemonView(dataSource: self, delegate: self)
    }()
    private var tableViewFooter = LoaderFooterView()
    
    // MARK: - Private properties
    
    private var pokemonsFRC: NSFetchedResultsController<PokemonEntity>?
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    func didSetViewModel(_ viewModel: PokemonVM, lifetime: Lifetime) {
        viewModel.useCases.pokemon.setupProducer.startWithResult { [weak self] result in
            guard let viewController = self else { return }
            switch result {
            case .success(let database):
                viewController.setupFRC(with: database.viewContext)
            case .failure(let error):
                viewController.showErrorAlert(error)
            }
        }
        reactive.makeBindingTarget { viewController, hasMore in
            viewController.mainView.tableView.tableFooterView = hasMore ?
                viewController.tableViewFooter :
                nil
            viewController.tableViewFooter.setAnimating(hasMore)
        } <~ viewModel.pagination.map { $0.hasMore }.skipRepeats()
        
        let activityActionGroup = ActionGroup()
        activityActionGroup.append(viewModel.fetchPokemonInfo)
        
        reactive.activity <~ activityActionGroup.isExecuting
        reactive.errors <~ viewModel.actions.errors
    }
    
    // MARK: - Helper methods
    
    private func setup() {
        navigationItem.title = localizedString(key: "pokemonVC.title").uppercased()
    }
    
    private func setupFRC(with context: NSManagedObjectContext) {
        pokemonsFRC = NSFetchedResultsController(fetchRequest: viewModel.useCases.pokemon.pokemonsFetchRequest(),
                                                 managedObjectContext: context,
                                                 sectionNameKeyPath: nil,
                                                 cacheName: nil)
        pokemonsFRC?.delegate = self
        do {
            try pokemonsFRC?.performFetch()
            if pokemonsFRC?.fetchedObjects?.count == 0 {
                viewModel.fetchPokemonsAction.apply(0).start()
            }
        } catch {
            assertionFailure(error.localizedDescription)
        }
    }
}

// MARK: - UITableViewDataSource

extension PokemonVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemonsFRC?.sections?[section].objects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let pokemonEntity = pokemonsFRC?.object(at: indexPath) else { return UITableViewCell() }
        let media = pokemonEntity.imageLink.flatMap { URL(string: $0) }.flatMap {
            viewModel.useCases.download.add(from: $0, ownerID: pokemonEntity.id)
        }
        
        let cell = tableView.dequeueReusableCell(cellClass: PokemonTVC.self)
        cell.configure(with: pokemonEntity, media: media)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension PokemonVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard NetworkReachability.isConnected(),
              !viewModel.fetchPokemonsAction.isExecuting.value,
              viewModel.pagination.value.hasMore,
              let fetchedObjects = pokemonsFRC?.fetchedObjects,
              indexPath.row >= fetchedObjects.count - 20 else { return }
        viewModel.fetchPokemonsAction.apply(fetchedObjects.count - 1).start()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pokemonEntity = pokemonsFRC?.object(at: indexPath) else { return }
        viewModel.selectPokemonEntity(pokemonEntity)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension PokemonVC: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            mainView.tableView.insertRows(at: [newIndexPath], with: .right)
        case .delete:
            guard let indexPath = indexPath else { return }
            mainView.tableView.deleteRows(at: [indexPath], with: .right)
        case .update:
            guard let indexPath = indexPath else { return }
            mainView.tableView.reloadRows(at: [indexPath], with: .none)
        case .move:
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            if indexPath != newIndexPath {
                mainView.tableView.deleteRows(at: [indexPath], with: .right)
                mainView.tableView.insertRows(at: [newIndexPath], with: .right)
            } else {
                mainView.tableView.reloadRows(at: [indexPath], with: .none)
            }
        @unknown default:
            assertionFailure("NSFetchedResultsController @unknown default")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        mainView.tableView.endUpdates()
    }
}
