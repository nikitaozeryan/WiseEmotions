//
//  StatTVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 10.02.2021.
//

import UIKit
 
final class StatTVC: UITableViewCell {
    
    // MARK: - Views
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameDetailView, valueDetailView, effortDetailView])
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
    private lazy var valueDetailView: DetailView = {
        let view = DetailView(with: "Description", value: "Value")
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var effortDetailView: DetailView = {
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
    
    func configure(with stat: Stat) {
        nameDetailView.configure(with: localizedString(key: "stat.name"), value: stat.name)
        valueDetailView.configure(with: localizedString(key: "stat.value"), value: "\(stat.value)")
        effortDetailView.configure(with: localizedString(key: "stat.effor"), value: "\(stat.effort)")
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
