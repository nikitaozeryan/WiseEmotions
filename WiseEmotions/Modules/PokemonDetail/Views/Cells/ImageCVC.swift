//
//  ImageCVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 14.02.2021.
//

import UIKit

final class ImageCVC: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let reuseIdentifier = String(describing: ImageCVC.self)
    
    // MARK: - Private properties
    
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
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
    }
    
    private func setupConstraints() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        let avatarImageViewConstraints = [
            avatarImageView.leftAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leftAnchor),
            avatarImageView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            avatarImageView.centerYAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerYAnchor),
            avatarImageView.centerXAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.centerXAnchor),
        ]
        NSLayoutConstraint.activate(avatarImageViewConstraints)
    }
}

extension ImageCVC: MediaObserver {
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
