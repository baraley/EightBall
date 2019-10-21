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

		let answersCountingModel = AnswersCountingModel(secureStorage: SecureStorage())

		let answerSetsCoreDataService = CoreDataModelService<ManagedAnswerSet, AnswerSet>(
			context: answerSetsContext,
			fetchRequest: ConfiguredFetchRequest .answerSetsRequest,
			toModelConverter: AnswerSet.init
		)
		let historyAnswersCoreDataService = CoreDataModelService<ManagedHistoryAnswer, HistoryAnswer>(
			context: historyAnswersContext,
			fetchRequest: ConfiguredFetchRequest .managedHistoryAnswersRequest,
			toModelConverter: HistoryAnswer.init
		)

		let answerSetsModel = AnswerSetsModel(answerSetsService: answerSetsCoreDataService)
		let historyAnswersModel = HistoryAnswersModel(historyAnswersService: historyAnswersCoreDataService)
		let answerSettingsModel = AnswerSettingsModel(
			settingsService: SettingsService(),
			historyAnswersModel: historyAnswersModel,
			historyCleaner: HistoryCleanerService(context: historyAnswersContext)
		)

		let answerSourcesCoreDataService = CoreDataModelService<ManagedAnswerSet, AnswerSet>(
			context: answerSetsContext,
			fetchRequest: ConfiguredFetchRequest .notEmptyAnswerSetsRequest,
			toModelConverter: AnswerSet.init
		)

		let answerSourcesModel = AnswerSourcesModel(
			answerSourcesService: answerSourcesCoreDataService,
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
