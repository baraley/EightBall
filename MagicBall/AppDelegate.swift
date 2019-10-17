//
//  AppDelegate.swift
//  MagicBall
//
//  Created by Alexander Baraley on 8/6/19.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import UIKit
import CoreData

private let modelFileName = "MagicBallModel"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	private var persistentContainer: NSPersistentContainer = NSPersistentContainer(name: modelFileName)

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
	) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)

		let isNeedToCreateDefaultData = NSPersistentContainer.isPersistentStoreEmpty()

		persistentContainer.loadPersistentStores { (_, error) in
			if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
			}
			self.handlePersistentContainerLoadingAnd(createDefaultData: isNeedToCreateDefaultData)
		}

		return true
	}

	private func handlePersistentContainerLoadingAnd(createDefaultData isNeedDefaultData: Bool) {
		let answerSetsContext = persistentContainer.newBackgroundContext()
		let historyAnswersContext = persistentContainer.newBackgroundContext()

		 if isNeedDefaultData {
			let wasMigrated = MigratorFromDataFilesToCoreData.restoreAnswersSetsIfAvailableIn(answerSetsContext)

			if !wasMigrated {
				DefaultDataProvider.createDefaultAnswerSetIn(answerSetsContext)
			}
		}
		let answerSetsService = AnswerSetsService(context: answerSetsContext)
		let historyAnswersService = HistoryAnswersService(context: historyAnswersContext)

		window?.rootViewController = initializeAppRootViewController(with: answerSetsService, and: historyAnswersService)
		window?.makeKeyAndVisible()
	}

	private func initializeAppRootViewController(
		with answerSetsService: AnswerSetsService,
		and historyAnswersService: HistoryAnswersService
	) -> AppRootViewController {

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
