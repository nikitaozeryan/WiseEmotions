//
//  NavigationView.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import ReactiveSwift

class NavigationView: UIView {
    private weak var navigationController: UINavigationController?
    private weak var top: NSLayoutConstraint?
    private weak var leading: NSLayoutConstraint?
    private weak var bottom: NSLayoutConstraint?
    private weak var trailing: NSLayoutConstraint?
    
    convenience init(with navigationController: UINavigationController) {
        self.init(frame: navigationController.navigationBar.bounds)
        self.navigationController = navigationController
        setup(for: navigationController.navigationBar)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        if newSuperview != nil {
            setNeedsUpdateConstraints()
        }
    }
    
    private func setup(for navigationBar: UINavigationBar) {
        backgroundColor = .clear
        translatesAutoresizingMaskIntoConstraints = false
        layer.zPosition = -1
        isUserInteractionEnabled = false
        
        navigationBar.insertSubview(self, at: 0)
        
        reactive.makeBindingTarget { view, newSuperview in
            if newSuperview != nil {
                view.setNeedsUpdateConstraints()
            }
        } <~ navigationBar.reactive
            .signal(for: #selector(UIView.willMove(toSuperview:)))
            .compactMap { $0.first as? UIView? }
    }
    
    override func updateConstraints() {
        defer {
            super.updateConstraints()
        }
        guard let navigationController = navigationController else { return }
        let navigationBar = navigationController.navigationBar
        
        if self.top == nil {
            top = with(topAnchor.constraint(equalTo: navigationController.view.topAnchor)) {
                $0.priority = UILayoutPriority(999)
                $0.isActive = true
            }
        }
        if self.leading == nil {
            leading = with(leadingAnchor.constraint(equalTo: navigationBar.leadingAnchor)) {
                $0.isActive = true
            }
        }
        if self.bottom == nil {
            bottom = with(bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor)) {
                $0.isActive = true
            }
        }
        if self.trailing == nil {
            trailing = with(trailingAnchor.constraint(equalTo: navigationBar.trailingAnchor)) {
                $0.isActive = true
            }
        }
    }
}
