//
//  DetailHeaderView.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import UIKit

final class DetailHeaderView: UITableViewHeaderFooterView {
    
    // MARK: - Views
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: defaultFontSize)
        label.textColor = .blue
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    func setup(_ title: String) {
        titleLabel.text = title
    }
    
    // MARK: - Private methods
    
    private func setupUI() {
        addSubview(titleLabel)
    }
    
    // MARK: - Constraints
    
    private func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            titleLabel.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: offset),
            titleLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: offset)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
