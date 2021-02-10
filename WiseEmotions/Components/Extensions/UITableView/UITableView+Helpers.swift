//
//  UITableView+Helpers.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UITableView {
    func register<T>(_ cellClass: T.Type) where T: UITableViewCell {
        let identifier = String(describing: cellClass)
        register(cellClass, forCellReuseIdentifier: identifier)
    }
    
    func register<T>(_ viewClass: T.Type) where T: UITableViewHeaderFooterView {
        let identifier = String(describing: viewClass)
        register(viewClass, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass), for: indexPath) as? T else {
            fatalError("Cannot find cell \(String(describing: cellClass))")
        }
        return cell
    }
    
    func dequeueReusableCell<T: UITableViewCell>(cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellClass)) as? T else {
            fatalError("Cannot find cell \(String(describing: cellClass))")
        }
        return cell
    }
    
    func dequeueReusableFooter<T: UIView>(footerClass: T.Type) -> T {
        guard let footer = dequeueReusableHeaderFooterView(withIdentifier: String(describing: footerClass)) as? T else {
            fatalError("Cannot find footer \(String(describing: footerClass))")
        }
        return footer
    }
    
    func dequeueReusableHeader<T: UIView>(headerClass: T.Type) -> T {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: String(describing: headerClass)) as? T else {
            fatalError("Cannot find header \(String(describing: headerClass))")
        }
        return header
    }
    
    func makeCell<T: UITableViewCell>(at indexPath: IndexPath, builder: (T) -> Void) -> T {
        let cell = dequeueReusableCell(cellClass: T.self, for: indexPath)
        builder(cell)
        return cell
    }
}
