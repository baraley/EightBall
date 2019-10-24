//
//  AppDelegate.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)

		let dependencyContainer = AppDependencyContainer()

		dependencyContainer.prepareInitialDependencies {
			self.window?.rootViewController = AppRootViewController(appDependencyContainer: dependencyContainer)
			self.window?.makeKeyAndVisible()
		}

		return true
	}
}
