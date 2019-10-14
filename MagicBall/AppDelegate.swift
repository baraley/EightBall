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

	private var persistentContainer = NSPersistentContainer(name: modelFileName)

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
		let backgroundContext = persistentContainer.newBackgroundContext()

		 if isNeedDefaultData {
			let wasMigrated = MigratorFromDataFilesToCoreData.restoreAnswersSetsIfAvailableIn(backgroundContext)

			if !wasMigrated {
				DefaultDataProvider.createDefaultAnswerSetIn(backgroundContext)
			}
		}
		let answerSetsService = AnswerSetsService(context: backgroundContext)

		window?.rootViewController = initializeAppRootViewController(with: answerSetsService)
		window?.makeKeyAndVisible()
	}

	private func initializeAppRootViewController(with answerSetsService: AnswerSetsService) -> AppRootViewController {

		let answersCountingModel = AnswersCountingModel(secureStorage: SecureStorage())
		let answerSetsModel = AnswerSetsModel(answerSetsService: answerSetsService)

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
			answerSetsModel: answerSetsModel,
			answersCountingModel: answersCountingModel
		)

		return viewController
	}

}
