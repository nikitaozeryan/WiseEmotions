//
//  AppCoordinator.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import ReactiveSwift

final class AppCoordinator {
    
    // MARK: - Properties
    
    let window: UIWindow = UIWindow(frame: UIScreen.main.bounds)
    
    private let useCases: UseCasesProvider
    private let (lifetime, token) = Lifetime.make()
    private lazy var showSuccessedConfirm: Bool = false
    
    // MARK: - Setup
    
    init(useCases: UseCasesProvider) {
        self.useCases = useCases
        
        setup()
    }
    
    private func setup() {
        let navigationController = BaseNavigationVC()
        window.rootViewController = navigationController
        let coordinator = PokemonCoordinator(navigationController: navigationController,
                                             useCases: useCases)
        coordinator.start()
        window.makeKeyAndVisible()
    }
}
