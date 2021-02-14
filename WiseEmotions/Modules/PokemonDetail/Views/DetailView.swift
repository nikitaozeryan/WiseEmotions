//
//  DetailView.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 10.02.2021.
//

import UIKit

final class DetailView: UIView {
    private enum C {
        static let labelHeight: CGFloat = 20.0
    }
    
    // MARK: - Views
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.font = .systemFont(ofSize: titleFontSize)
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.textColor = .brown
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: defaultFontSize)
        return label
    }()
    
    // MARK: - Lifecycle
    
    init(with description: String, value: String) {
        super.init(frame: .zero)
        
        setup(with: description, value: value)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper methods
    
    func configure(with description: String, value: String) {
        descriptionLabel.text = description
        valueLabel.text = value
    }
    
    // MARK: - Private methods
    
    private func setup(with description: String, value: String) {
        addSubview(descriptionLabel)
        addSubview(valueLabel)
        
        descriptionLabel.text = description
        valueLabel.text = value
    }
    
    private func setupConstraints() {
        let descriptionLabelConstraints = [
            descriptionLabel.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor, constant: offset),
            descriptionLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            descriptionLabel.heightAnchor.constraint(equalToConstant: C.labelHeight),
            descriptionLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor)
        ]
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        
        let valueLabelConstraints = [
            valueLabel.leftAnchor.constraint(equalTo: descriptionLabel.safeAreaLayoutGuide.rightAnchor, constant: offset),
            valueLabel.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor, constant: offset),
            valueLabel.centerYAnchor.constraint(equalTo: descriptionLabel.safeAreaLayoutGuide.centerYAnchor),
            valueLabel.heightAnchor.constraint(equalToConstant: C.labelHeight)
        ]
        NSLayoutConstraint.activate(valueLabelConstraints)
    }
}
