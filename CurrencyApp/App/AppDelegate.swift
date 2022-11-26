//
//  AppDelegate.swift
//  CurrencyApp
//
//  Created by Dina Ragab on 25/11/2022.
//

import UIKit
//Apikey: cgoljnBUi3aK6xLkfDYMTq63P2hkn5or
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var applicationCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.checkSearchHistory()
        self.enableIQkeyboard()
        self.setupApplicationCoordinator()
        self.setupIntialView()
        return true
    }
}

