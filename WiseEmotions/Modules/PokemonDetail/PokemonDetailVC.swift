//  
//  PokemonDetailVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import ReactiveSwift
import UIKit

extension PokemonDetailVC: Makeable {
    static func make() -> PokemonDetailVC {
        return PokemonDetailVC()
    }
}

final class PokemonDetailVC: BaseVC, ViewModelContainer {
    private enum Section: Int, CaseIterable {
        case image
        case stats
        case types
        
        var title: String {
            switch self {
            case .image:
                return ""
            case .stats:
                return localizedString(key: "pokemon.detail.stats")
            default:
                return localizedString(key: "pokemon.detail.types")
            }
        }
        
        var cellHeight: CGFloat {
            switch self {
            case .image:
                return UITableView.automaticDimension
            case .stats:
                return 116.0
            case .types:
                return 88.0
            }
        }
    }
    
    // MARK: - Properties
    
    private lazy var mainView: PokemonDetailView = {
        PokemonDetailView(dataSource: self, delegate: self)
    }()
    
    private lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        var layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth / 3 - offset * 2, height: screenWidth / 3 - offset * 2)
        layout.minimumInteritemSpacing = offset
        layout.scrollDirection = .horizontal
        return layout
    }()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        super.loadView()
        
        view = mainView
    }
    
    func didSetViewModel(_ viewModel: PokemonDetailVM, lifetime: Lifetime) {
        navigationItem.title = viewModel.pokemon.name
    }
}

// MARK: - UITableViewDataSource

extension PokemonDetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .image:
            return 1
        case .stats:
            return viewModel.pokemon.stats.count
        case .types:
            return viewModel.sortedTypes.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else { return UITableViewCell() }
        switch section {
        case .image:
            let cell = tableView.dequeueReusableCell(cellClass: PokemonAvatarsTVC.self)
            cell.configure(with: self, layout: collectionViewLayout)
            return cell
        case .stats:
            let cell = tableView.dequeueReusableCell(cellClass: StatTVC.self)
            cell.configure(with: viewModel.pokemon.stats[indexPath.row])
            return cell
        case .types:
            let cell = tableView.dequeueReusableCell(cellClass: TypeTVC.self)
            cell.configure(with: viewModel.sortedTypes[indexPath.row])
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension PokemonDetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section),
              section != .image else { return nil }
        let header = tableView.dequeueReusableHeader(headerClass: DetailHeaderView.self)
        header.setup(section.title)
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let section = Section(rawValue: section),
              section != .image else { return .leastNormalMagnitude }
        return defaultHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return UITableView.automaticDimension }
        return section.cellHeight
    }
}


// MARK: - UICollectionViewDataSource

extension PokemonDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemon.imageURLS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCVC.reuseIdentifier, for: indexPath) as? ImageCVC else { return UICollectionViewCell() }
        let media = viewModel.useCases.download.add(from: viewModel.pokemon.imageURLS[indexPath.item],
                                                            ownerID: viewModel.pokemon.id)
        cell.configure(with: media)
        return cell
    }
}
