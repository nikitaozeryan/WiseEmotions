//
//  PokemonAvatarTVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 10.02.2021.
//

import UIKit

final class PokemonAvatarTVC: UITableViewCell {
    
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
    
    func configure(with media: Media?) {
        self.media.flatMap { stopObservingUpdates(for: $0) }
        self.media = media
        media.flatMap{ observeUpdates(for: $0) }
        avatarImageView.image = media?.image ?? pokemonPlaceholder
    }
    
    // MARK: - Private methods
    
    private func setup() {
        contentView.addSubview(avatarImageView)
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarImageViewConstraints = [
            avatarImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: offset),
            avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: defaultImageSize.height * 3),
            avatarImageView.widthAnchor.constraint(equalToConstant: defaultImageSize.width * 3)
        ]
        NSLayoutConstraint.activate(avatarImageViewConstraints)
    }
}

extension PokemonAvatarTVC: MediaObserver {
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
