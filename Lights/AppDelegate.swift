//
//  AppDelegate.swift
//  Lights
//
//  Created by Nathan Borror on 2/2/15.
//  Copyright (c) 2015 Nathan Borror. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()

        let viewController = ViewController()

        self.window!.rootViewController = viewController
        self.window!.makeKeyAndVisible()
        return true
    }

}

