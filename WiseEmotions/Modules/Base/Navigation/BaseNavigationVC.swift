//
//  BaseNavigationVC.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit

@objc protocol NavigationBarAppearance: class {
    var prefersNavigationBarHidden: Bool { get }
    var prefersShadowImage: UIImage? { get }
    var preferredNavigationBarTintColor: UIColor? { get }
}

extension UIViewController: NavigationBarAppearance {
    var prefersNavigationBarHidden: Bool {
        return false
    }
    
    var prefersShadowImage: UIImage? {
        return nil
    }
    
    var preferredNavigationBarTintColor: UIColor? {
        return nil
    }
}

class BaseNavigationVC: UINavigationController {
    private(set) lazy var navigationView: NavigationView = {
        let view = NavigationView(with: self)
        view.backgroundColor = .clear
        return view
    }()
    
    // MARK: - Override
    
    override func loadView() {
        super.loadView()
        
        navigationBar.barTintColor = .clear
        navigationBar.tintColor = .white
        navigationBar.barStyle = .black
        navigationBar.isTranslucent = true
        delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationView.isHidden = topViewController?.prefersNavigationBarHidden ?? false
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        
        setNavigationViewHidden(hidden, animated: animated)
    }
    
    func setNavigationViewHidden(_ hidden: Bool, animated: Bool) {
        let duration: TimeInterval = animated ? Double(UINavigationController.hideShowBarDuration) : 0.0
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .beginFromCurrentState,
                       animations: {
                        self.navigationView.transform = hidden ?
                            CGAffineTransform(translationX: 0.0, y: -self.navigationView.frame.height) : CGAffineTransform.identity
        },
                       completion: { _ in
        })
    }
    
    // MARK: - Private
    
    private func setupController() {
        let image = UIImage()
        navigationBar.setBackgroundImage(image, for: .default)
        navigationBar.shadowImage = image
        
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.blue]
            navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.blue]
            navigationBar.standardAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.blue]
        }
        
        delegate = self
    }
    
    private func setupBackButtonStyle(for viewController: UIViewController) {
        CATransaction.begin()
        let topItem = navigationBar.topItem
        navigationBar.backIndicatorImage = nil
        navigationBar.backIndicatorTransitionMaskImage = nil
        let backButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        topItem?.backBarButtonItem = backButtonItem
        CATransaction.commit()
    }
}

extension BaseNavigationVC: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    func navigationController(_ navigationController: UINavigationController,
                              willShow viewController: UIViewController,
                              animated: Bool) {
        setupBackButton(for: viewController)
        
        let oldBarStyle = navigationBar.barStyle
        let oldShadowImage = navigationBar.shadowImage
        let barStyle = viewController.preferredStatusBarStyle == .lightContent ? UIBarStyle.black : UIBarStyle.default
        let preferredTintColor = viewController.preferredNavigationBarTintColor ?? .white
        
        guard
            animated,
            let transitionCoordinator = transitionCoordinator,
            let fromController = transitionCoordinator.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toController = transitionCoordinator.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                setupNavigationView(for: viewController, with: barStyle, preferredTintColor: preferredTintColor)
                return
        }
        
        let isFromNavigationBarHidden = fromController.prefersNavigationBarHidden
        let isToNavigationBarHidden = toController.prefersNavigationBarHidden
        
        let shadowImage = isToNavigationBarHidden ? UIImage() : nil
        
        guard isFromNavigationBarHidden != isToNavigationBarHidden else { return }
        
        if !isToNavigationBarHidden {
            navigationView.removeFromSuperview()
            navigationBar.insertSubview(navigationView, at: 0)
        }
        
        let operation: UINavigationController.Operation = viewControllers.firstIndex(of: fromController) != nil ? .push : .pop
        
        var initialTransform: CGAffineTransform = .identity
        var targetTransform: CGAffineTransform = .identity
        self.navigationView.isHidden = false
        
        setupTransforms(initial: &initialTransform, target: &targetTransform,
                        for: operation, isFromNavigationBarHidden: isFromNavigationBarHidden)
        
        navigationView.transform = initialTransform
        
        transitionCoordinator.animate(
            alongsideTransition: { context in
                self.navigationBar.barStyle = barStyle
                self.navigationBar.tintColor = preferredTintColor
                self.navigationBar.shadowImage = shadowImage
        },
            completion: { context in
                if context.isCancelled {
                    self.navigationBar.barStyle = oldBarStyle
                    self.navigationBar.shadowImage = oldShadowImage
                } else {
                    self.navigationView.isHidden = isToNavigationBarHidden
                }
        })
        
        transitionCoordinator.animateAlongsideTransition(in: view, animation: { _ in
            self.navigationView.transform = targetTransform
        })
    }
    
    // MARK: - Private
    
    private func setupBackButton(for viewController: UIViewController) {
        if let controller = viewController as? BaseVC, controller.shouldHideBackBarButtonItem {
            navigationBar.topItem?.leftBarButtonItems = []
            controller.navigationItem.leftBarButtonItems = []
            controller.navigationItem.hidesBackButton = true
        } else {
            setupBackButtonStyle(for: viewController)
        }
    }
    
    private func setupNavigationView(for viewController: UIViewController,
                                     with barStyle: UIBarStyle,
                                     preferredTintColor: UIColor) {
        navigationView.isHidden = viewController.prefersNavigationBarHidden
        if navigationView.backgroundColor == .clear {
            navigationBar.barStyle = barStyle
        }
        navigationBar.shadowImage = viewController.prefersNavigationBarHidden ? UIImage() : viewController.prefersShadowImage
        navigationBar.tintColor = preferredTintColor
    }
    
    private func setupTransforms(initial initialTransform: inout CGAffineTransform,
                                 target targetTransform: inout CGAffineTransform,
                                 for operation: UINavigationController.Operation,
                                 isFromNavigationBarHidden: Bool) {
        switch operation {
        case .push:
            if isFromNavigationBarHidden {
                initialTransform = CGAffineTransform(translationX: navigationView.frame.width, y: 0)
                targetTransform = CGAffineTransform.identity
            } else {
                initialTransform = CGAffineTransform.identity
                targetTransform = CGAffineTransform(translationX: -navigationView.frame.width, y: 0)
            }
        case .pop:
            if isFromNavigationBarHidden {
                initialTransform = CGAffineTransform(translationX: -navigationView.frame.width, y: 0)
                targetTransform = CGAffineTransform.identity
            } else {
                initialTransform = CGAffineTransform.identity
                targetTransform = CGAffineTransform(translationX: navigationView.frame.width, y: 0)
            }
        default:
            break
        }
    }
}
