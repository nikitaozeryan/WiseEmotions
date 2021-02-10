//
//  BaseVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import ReactiveSwift
import ReactiveCocoa

class BaseVC: UIViewController {
    enum C {
        static let activityAnimationDuration: TimeInterval = 0.25
        static let activityGraceTime: TimeInterval = 0.1
    }
    
    // MARK: - UI
    @IBInspectable var isNavigationBarHidden: Bool = false
    
    // MARK: - Lifecycle
    private(set)lazy var isActive: Property<Bool> =
        Property(initial: false, then: reactive.isActive)
    private(set)lazy var isVisible: Property<Bool> =
        Property(initial: false, then: reactive.isVisible)
    private(set)lazy var didLayout: Property<Bool> =
        Property(initial: false,
                 then: reactive.viewDidLayoutSubviews.take(first: 1).map(value: true))
    
    var shouldHideBackBarButtonItem = false
    
    override func loadView() {
        super.loadView()
        
        _ = isActive
        _ = isVisible
        _ = didLayout
        
        needsFetchData <~ UIApplication.shared.reactive.willResignActive.map(value: true)
        
        let becomeVisible = reactive.isVisible.filter { $0 }.map(value: ())
        let didBecomeActive = UIApplication.shared.reactive
            .didBecomeActive
            .skip(until: becomeVisible)
        Signal.merge(becomeVisible, didBecomeActive)
            .withLatest(from: needsFetchData.combineLatest(with: isVisible))
            .filter { (_, arg1) -> Bool in
                let (subArg1, subArg2) = arg1
                return subArg1 && subArg2
        }.map { [needsFetchData] _ -> Void in
            needsFetchData.value = false
            return ()
        }
        .observe(fetchDataPipe.input)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(isNavigationBarHidden, animated: animated)
    }
    
    deinit {
        #if DEBUG
        print("\(#function) \(self)")
        #endif
    }
    
    @objc func popVC() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: -
    
    var placeholderText: String {
        return "No content"
    }
    
    var placeholderOffset: CGFloat {
        return centerOffset
    }
    
    var activityOffset: CGFloat {
        return centerOffset
    }
    
    var centerOffset: CGFloat {
        return 0
    }
    
    // MARK: - Fetch Data
    private let needsFetchData = MutableProperty(true)
    private let fetchDataPipe = Signal<(), Never>.pipe()
    
    func setNeedsFetchData() {
        needsFetchData.value = true
    }
    var fetchDataTrigger: Signal<(), Never> {
        return fetchDataPipe.output
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Activity
    
    private lazy var activityView = makeActivityView()
    
    func makeActivityView() -> ActivityView {
        let activityView = ActivityView(frame: view.bounds)
        activityView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        activityView.alpha = 0
        view.addSubview(activityView)
        return activityView
    }
    
    func showActivity(animated: Bool = true) {
        let duration: TimeInterval = animated ? C.activityAnimationDuration : 0
        let delay: TimeInterval = animated ? C.activityGraceTime : 0
        UIView.animate(withDuration: duration, delay: delay, options: .beginFromCurrentState, animations: {
            self.activityView.alpha = 1.0
            self.activityView.isAnimating = true
        })
    }
    
    func hideActivity(animated: Bool = true) {
        let duration: TimeInterval = animated ? C.activityAnimationDuration : 0
        UIView.animate(withDuration: duration, delay: 0.0, options: .beginFromCurrentState, animations: {
            self.activityView.alpha = 0.0
        })
    }
    
    // MARK: - Alert
    
    func showErrorAlert(_ error: Error, handler: ((UIAlertAction) -> Void)? = nil) {
        guard shouldShowAlert(for: error) else { return }
        
        let controller = UIAlertController(title: localizedString(key: "error"),
                                           message: error.localizedDescription,
                                           preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: localizedString(key: "ok"),
                                           style: .default,
                                           handler: handler))
        present(controller, animated: true)
    }
    
    func shouldShowAlert(for error: Error) -> Bool {
        return true
    }
}

extension Reactive where Base: BaseVC {
    var activity: BindingTarget<Bool> {
        return makeBindingTarget { base, isExecuting in
            if isExecuting {
                base.showActivity()
            } else {
                base.hideActivity()
            }
        }
    }
    
    var errors: BindingTarget<Error> {
        return makeBindingTarget { base, error in
            let error = AppError(error)
            base.showErrorAlert(error)
        }
    }
}
