//
//  PokemonDetailView.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 10.02.2021.
//

import UIKit

final class PokemonDetailView: UIView {
    
    // MARK: - Views
    
    private(set) lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: .zero,
                                                left: offset,
                                                bottom: .zero,
                                                right: .zero)
        
        tableView.register(DetailHeaderView.self)
        tableView.register(PokemonAvatarsTVC.self)
        tableView.register(StatTVC.self)
        tableView.register(TypeTVC.self)
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    // MARK: - Lifecycle
    
    init(dataSource: UITableViewDataSource,
         delegate: UITableViewDelegate) {
        super.init(frame: .zero)
        
        setup(dataSource: dataSource,
              delegate: delegate)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    private func setup(dataSource: UITableViewDataSource,
                       delegate: UITableViewDelegate) {
        
        if #available(iOS 13.0, *) {
            backgroundColor = .systemBackground
        } else {
            backgroundColor = .white
        }
        
        addSubview(tableView)
        tableView.dataSource = dataSource
        tableView.delegate = delegate
    }
    
    private func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            tableView.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            tableView.leftAnchor.constraint(equalTo: leftAnchor),
            tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: offset),
            tableView.rightAnchor.constraint(equalTo: rightAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
