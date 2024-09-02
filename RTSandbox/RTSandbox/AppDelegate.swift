//
//  AppDelegate.swift
//  RTSandbox
//
//  Created by RT on 2024/8/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = ViewController.init()
        window?.backgroundColor = UIColor.red
        window?.makeKeyAndVisible()
        return true
    }


}

