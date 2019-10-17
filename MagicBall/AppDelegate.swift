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

		let coreDataContainer = CoreDataContainer()

		let isNeedToCreateDefaultData = coreDataContainer.isPersistentStoreEmpty

		coreDataContainer.loadPersistentStores {
			if isNeedToCreateDefaultData {
				coreDataContainer.restoreData()
			}
			self.window?.rootViewController = self.initializeRootViewController(with: coreDataContainer)
			self.window?.makeKeyAndVisible()
		}

		return true
	}

	private func initializeRootViewController(with coreDataContainer: CoreDataContainer) -> AppRootViewController {

		let answerSetsContext = coreDataContainer.newBackgroundContext()
		let historyAnswersContext = coreDataContainer.newBackgroundContext()

		let answerSetsService = AnswerSetsService(context: answerSetsContext)
		let historyAnswersService = HistoryAnswersService(context: historyAnswersContext)

		let answersCountingModel = AnswersCountingModel(secureStorage: SecureStorage())
		let answerSetsModel = AnswerSetsModel(answerSetsService: answerSetsService)
		let historyAnswersModel = HistoryAnswersModel(historyAnswerService: historyAnswersService)
		let answerSettingsModel = AnswerSettingsModel(
			settingsService: SettingsService(),
			historyAnswersModel: historyAnswersModel
		)

		let answerSourcesModel = AnswerSourcesModel(
			answerSetsModel: answerSetsModel,
			networkAnswerService: NetworkService(),
			historyAnswersModel: historyAnswersModel
		)
		let magicBallModel = MagicBallModel(
			answerSourceModel: answerSourcesModel,
			answerPronouncer: TextPronouncer(),
			answersCountingModel: answersCountingModel
		)
		let viewController = AppRootViewController(
			magicBallModel: magicBallModel,
			answerSourcesModel: answerSourcesModel,
			historyAnswersModel: historyAnswersModel,
			answerSettingsModel: answerSettingsModel,
			answerSetsModel: answerSetsModel,
			answersCountingModel: answersCountingModel
		)

		return viewController
	}

}
