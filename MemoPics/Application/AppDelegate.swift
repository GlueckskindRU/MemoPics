//
//  AppDelegate.swift
//  MemoPics
//
//  Created by Yuri Ivashin on 25.11.2019.
//  Copyright © 2019 The Homber Team. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var settingsController = SettingsController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if let homeScreenVC = Bundle.main.loadNibNamed(String(describing: HomeScreenViewController.self), owner: nil, options: nil)?.first as? HomeScreenViewController {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.backgroundColor = .white
            window?.rootViewController = homeScreenVC
            window?.makeKeyAndVisible()
        }
        
        return true
    }


}

