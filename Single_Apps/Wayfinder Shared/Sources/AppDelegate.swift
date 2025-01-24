//
//  AppDelegate.swift
//  Wayfinder
//
//  Created by Dylan Elliott on 25/7/17.
//  Copyright © 2017 Dylan Elliott. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = .toolbar
        UINavigationBar.appearance().tintColor = .h1
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.h2]

        return true
    }
}

