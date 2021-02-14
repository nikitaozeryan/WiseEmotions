//
//  AppDelegate.swift
//  WiseEmotions
//
//  Created by Nikita Ozerian on 07.02.2021.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    private lazy var platform = Platform()
    private lazy var appCoordinator = AppCoordinator(useCases: self.platform)
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = appCoordinator.window
        return true
    }
}

