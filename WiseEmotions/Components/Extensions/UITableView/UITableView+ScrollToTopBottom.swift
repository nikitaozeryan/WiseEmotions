//
//  UITableView+ScrollToTopBottom.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

extension UITableView {
    public func reloadData(_ completion: @escaping ()->()) {
        UIView.animate(withDuration: .zero, animations: {
            self.reloadData()
        }, completion: { _ in
            completion()
        })
    }

    func scroll(scrollTo: ScrollsTo, animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(300)) {
            let numberOfSections = self.numberOfSections
            let numberOfRows = self.numberOfRows(inSection: numberOfSections - 1)
            switch scrollTo {
            case .top:
                if numberOfRows > .zero {
                    let indexPath = IndexPath(row: .zero, section: .zero)
                     self.scrollToRow(at: indexPath, at: .top, animated: animated)
                }
                break
            case .bottom:
                if numberOfRows > .zero {
                    let indexPath = IndexPath(row: numberOfRows - 1, section: (numberOfSections - 1))
                    self.scrollToRow(at: indexPath, at: .bottom, animated: animated)
                }
                break
            }
        }
    }

    enum ScrollsTo {
        case top, bottom
    }
}
