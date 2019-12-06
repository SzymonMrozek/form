//
//  AppDelegate.swift
//  FormApproaching
//
//  Created by Szymon Mrozek on 30/11/2019.
//  Copyright © 2019 Szymon Mrozek. All rights reserved.
//

import UIKit
import Foundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let navigationController = UINavigationController()
        let coordinator = FormCoordinator(
            navigationController: navigationController,
            controllersBuilder: ControllersBuilder(dependencies: GlobalDependencies())
        )
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        coordinator.start()
        
//         mem leak test
//        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0, execute: { [weak self, weak navigationController] in
//            self?.window?.resignKey()
//            self?.window?.rootViewController = nil
//            navigationController?.setViewControllers([], animated: false)
//            self?.window = nil
//        })
        
        return true
    }
}

