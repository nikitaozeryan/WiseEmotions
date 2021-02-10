//
//  Reactive+UIView.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import ReactiveSwift
import ReactiveCocoa
import UIKit

extension Reactive where Base: UIView {
    var layoutSubviews: Signal<Void, Never> { trigger(for: #selector(Base.layoutSubviews)) }
    var setNeedsLayout: Signal<Void, Never> { trigger(for: #selector(Base.setNeedsLayout)) }
    var layoutIfNeeded: Signal<Void, Never> { trigger(for: #selector(Base.layoutIfNeeded)) }
}
