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
		window?.rootViewController = initializeAppRootViewController()
		window?.makeKeyAndVisible()

		return true
	}

	private func initializeAppRootViewController() -> AppRootViewController {

		let answersCountingModel = AnswersCountingModel(secureStorage: SecureStorage())
		let answerSetsModel = AnswerSetsModel(answerSetsService: AnswerSetsService())

		let answerSourcesModel = AnswerSourcesModel(
			answerSetsModel: answerSetsModel,
			networkAnswerService: NetworkService()
		)
		let magicBallModel = MagicBallModel(
			answerSourceModel: answerSourcesModel,
			answerPronouncer: TextPronouncer(),
			answersCountingModel: answersCountingModel
		)
		let viewController = AppRootViewController(
			magicBallModel: magicBallModel,
			answerSourcesModel: answerSourcesModel,
			answerSettingsModel: AnswerSettingsModel(settingsService: SettingsService()),
			answerSetsModel: answerSetsModel
		)

		return viewController
	}

}
