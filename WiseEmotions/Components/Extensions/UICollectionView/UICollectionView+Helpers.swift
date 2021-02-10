//
//  UICollectionView+Helpers.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UICollectionView {
    func registerNib<T>(for cellClass: T.Type) where T: UICollectionViewCell {
        let identifier = String(describing: cellClass)
        register(UINib(nibName: identifier, bundle: nil), forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib<T>(for viewClass: T.Type) where T: UIView {
        let identifier = String(describing: viewClass)
        register(T.self, forSupplementaryViewOfKind: identifier, withReuseIdentifier: identifier)
    }
    
    func dequeueReusableCollectionViewCell<T: UICollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withReuseIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            fatalError("Cannot find cell \(String(describing: cellClass))")
        }
        return cell
    }
    
    func dequeueReusableSupplementaryView<T: UIView>(footerClass: T.Type, for indexPath: IndexPath) -> T {
        guard let view = dequeueReusableSupplementaryView(ofKind: String(describing: footerClass),
                                                          withReuseIdentifier: String(describing: footerClass),
                                                          for: indexPath) as? T else {
                                                            fatalError("Cannot find supplementary view \(String(describing: footerClass))")
        }
        return view
    }
    
    func makeCell<T: UICollectionViewCell>(at indexPath: IndexPath, builder: (T) -> Void) -> T {
        let cell = dequeueReusableCollectionViewCell(cellClass: T.self, for: indexPath)
        builder(cell)
        return cell
    }
}
