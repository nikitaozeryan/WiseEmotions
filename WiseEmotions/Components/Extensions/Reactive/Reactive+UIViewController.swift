//
//  UIViewController+Reactive.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift
import ReactiveCocoa
import UIKit

public extension Reactive where Base: UIViewController {
    
    var viewDidLoad: Signal<Void, Never> {
        return trigger(for: #selector(Base.viewDidLoad))
    }
    
    var viewWillAppear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewWillAppear(_:)))
            .map { ($0.first as? Bool) ?? false }
    }
    
    var viewDidAppear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewDidAppear(_:)))
            .map { ($0.first as? Bool) ?? false }
    }
    
    var viewWillDisappear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewWillDisappear(_:)))
            .map { ($0.first as? Bool) ?? false }
    }
    
    var viewDidDisappear: Signal<Bool, Never> {
        return signal(for: #selector(Base.viewDidDisappear(_:)))
            .map { ($0.first as? Bool) ?? false }
    }
    
    var viewWillLayoutSubviews: Signal<Void, Never> {
        return trigger(for: #selector(Base.viewWillLayoutSubviews))
    }
    
    var viewDidLayoutSubviews: Signal<Void, Never> {
        return trigger(for: #selector(Base.viewDidLayoutSubviews))
    }
    
    var didReceiveMemoryWarning: Signal<Void, Never> {
        return trigger(for: #selector(Base.didReceiveMemoryWarning))
    }
    
    var isActive: Signal<Bool, Never> {
        return Signal.merge(viewDidAppear.map { _ in true },
                            viewWillDisappear.map { _ in false })
    }
    
    var isVisible: Signal<Bool, Never> {
        return Signal.merge(viewWillAppear.map { _ in true },
                            viewDidDisappear.map { _ in false })
    }
}
