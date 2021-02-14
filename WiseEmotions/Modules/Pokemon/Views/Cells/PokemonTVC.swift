//
//  PokemonTVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 09.02.2021.
//

import UIKit

final class PokemonTVC: UITableViewCell {
    
    // MARK: - Properties
    
    private var media: Media?
    
    // MARK: - Views
    
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = pokemonPlaceholder
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: defaultFontSize)
        label.numberOfLines = 0
        label.textColor = .blue
        return label
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
    
    func configure(with pokemon: PokemonEntity, media: Media?) {
        self.media.flatMap { stopObservingUpdates(for: $0) }
        self.media = media
        media.flatMap{ observeUpdates(for: $0) }
        titleLabel.text = pokemon.name
        avatarImageView.image = media?.image ?? pokemonPlaceholder
    }
    
    // MARK: - Private methods
    
    private func setup() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(titleLabel)
        titleLabel.numberOfLines = 0
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarImageViewTopConstraint = avatarImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.topAnchor, constant: offset)
        avatarImageViewTopConstraint.priority = .defaultLow
        let avatarImageViewConstraints = [
            avatarImageViewTopConstraint,
            avatarImageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor, constant: offset),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: defaultImageSize.height),
            avatarImageView.widthAnchor.constraint(equalToConstant: defaultImageSize.width)
        ]
        NSLayoutConstraint.activate(avatarImageViewConstraints)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleLabelTopConstraint = avatarImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.safeAreaLayoutGuide.topAnchor, constant: offset)
        titleLabelTopConstraint.priority = .defaultHigh
        let titleLabelConstraints = [
            titleLabel.leftAnchor.constraint(equalTo: avatarImageView.safeAreaLayoutGuide.rightAnchor, constant: offset),
            titleLabel.rightAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.rightAnchor, constant: offset),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            titleLabelTopConstraint
        ]
        NSLayoutConstraint.activate(titleLabelConstraints)
    }
}

// MARK: - MediaObserver

extension PokemonTVC: MediaObserver {
    func media(_ media: Media, didUpdateStatus status: Media.Status) {
        guard media == self.media else { return }
        switch status {
        case .cancelled, .failed, .unknown, .downloading:
            self.avatarImageView.image = pokemonPlaceholder
        case .completed:
            self.avatarImageView.image = media.image
        }
    }
}
