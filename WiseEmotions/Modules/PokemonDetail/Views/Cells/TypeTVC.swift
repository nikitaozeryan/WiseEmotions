//
//  TypeTVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 10.02.2021.
//

import UIKit

final class TypeTVC: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameDetailView, slotDetailView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = offset / 2
        return stackView
    }()
    
    private lazy var nameDetailView: DetailView = {
        let view = DetailView(with: "Description", value: "Value")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var slotDetailView: DetailView = {
        let view = DetailView(with: "Description", value: "Value")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    
    func configure(with type: Type) {
        nameDetailView.configure(with: localizedString(key: "type.name"), value: type.name)
        slotDetailView.configure(with: localizedString(key: "type.slot"), value: "\(type.slot)")
    }
    
    // MARK: - Private methods
    
    private func setup() {
        contentView.addSubview(infoStackView)
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        infoStackView.translatesAutoresizingMaskIntoConstraints = false
        let infoStackViewConstraints = [
            infoStackView.leftAnchor.constraint(equalTo: leftAnchor),
            infoStackView.topAnchor.constraint(equalTo: topAnchor, constant: offset),
            infoStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            infoStackView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(infoStackViewConstraints)
    }
}
