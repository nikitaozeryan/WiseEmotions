//
//  ObservedRefreshControlProtocol.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift

extension UITableView {
    func addReactiveRefreshControl(action: CocoaAction<UIRefreshControl>) {
        refreshControl = with(UIRefreshControl()) { refreshControl in
            let refreshAction = action
            refreshControl.reactive.refresh = refreshAction
            reactive.makeBindingTarget { [refreshControl] _, isRefreshing in
                UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveLinear, animations: { [unowned self] in
                    guard !isRefreshing, self.contentOffset.y <= -refreshControl.frame.height else { return }
                    self.setContentOffset(.zero, animated: false)
                })
                } <~ refreshAction.isExecuting.skipRepeats().producer.filter { !$0 }
        }
    }
}
