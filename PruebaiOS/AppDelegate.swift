//
//  AppDelegate.swift
//  ProyectoBase
//
//  Created by Osvaldo González on 19/10/20.
//  Copyright © 2020 Osvaldo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       // guard let scene = (scene as? UIWindowScene) else { return }
        
        
        if true {
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = UINavigationController(rootViewController: MainController())
            window?.makeKeyAndVisible()
        }
        
        return true
      
    }
}

