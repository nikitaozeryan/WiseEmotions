//
//  PokemonAvatarsTVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 10.02.2021.
//

import UIKit

final class PokemonAvatarsTVC: UITableViewCell {
    
    // MARK: - Views
    
    private var avatarsCollectionView: UICollectionView?

    // MARK: - Private methods
    
    func configure(with dataSource: UICollectionViewDataSource, layout: UICollectionViewFlowLayout) {
        setup()
        avatarsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        avatarsCollectionView?.backgroundColor = .clear
        avatarsCollectionView?.register(ImageCVC.self, forCellWithReuseIdentifier: ImageCVC.reuseIdentifier)
        setupConstraints()
        avatarsCollectionView?.dataSource = dataSource
    }
    
    private func setup() {
        avatarsCollectionView?.removeFromSuperview()
        selectionStyle = .none
    }
    
    private func setupConstraints() {
        avatarsCollectionView.flatMap { contentView.addSubview($0) }
        avatarsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        let avatarsCollectionViewConstraints = [
            avatarsCollectionView?.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: offset),
            avatarsCollectionView?.topAnchor.constraint(equalTo: contentView.topAnchor, constant: offset),
            avatarsCollectionView?.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            avatarsCollectionView?.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            avatarsCollectionView?.heightAnchor.constraint(equalToConstant: defaultImageSize.height * 2),
            avatarsCollectionView?.widthAnchor.constraint(equalToConstant: defaultImageSize.width * 2)
        ].compactMap { $0 }
        NSLayoutConstraint.activate(avatarsCollectionViewConstraints)
    }
}
