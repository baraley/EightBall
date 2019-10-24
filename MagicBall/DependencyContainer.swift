//
//  DependencyContainer.swift
//  MagicBall
//
//  Created by Alexander Baraley on 24.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

class AppDependencyContainer {

	func prepareInitialDependencies(_ completionHandler: @escaping () -> Void) {
		let isNeedToCreateDefaultData = coreDataContainer.isPersistentStoreEmpty

		coreDataContainer.loadPersistentStores {
			if isNeedToCreateDefaultData {
				self.coreDataContainer.restoreData()
			}
			completionHandler()
		}
	}

	// MARK: - Dependencies

	lazy var answerSetsModel = AnswerSetsModel(answerSetsService: answerSetsCoreDataService)
	lazy var answersCountingModel = AnswersCountingModel(secureStorage: SecureStorage())
	lazy var historyAnswersModel = HistoryAnswersModel(historyAnswersService: historyAnswersCoreDataService)

	lazy var answerSourcesModel = AnswerSourcesModel(
		answerSourcesService: answerSourcesCoreDataService,
		networkAnswerService: NetworkService(),
		historyAnswersModel: historyAnswersModel
	)

	lazy var answerSettingsModel = AnswerSettingsModel(
		settingsService: SettingsService(),
		historyCleaner: HistoryCleanerService(context: historyAnswersContext)
	)

	// MARK: - Private Properties

	private let coreDataContainer = CoreDataContainer()

	private lazy var answerSetsContext = coreDataContainer.newBackgroundContext()
	private lazy var historyAnswersContext = coreDataContainer.newBackgroundContext()

	private lazy var answerSetsCoreDataService = CoreDataModelService<ManagedAnswerSet, AnswerSet>(
		context: answerSetsContext,
		fetchRequest: ConfiguredFetchRequest.answerSetsRequest,
		toModelConverter: AnswerSet.init
	)
	private lazy var historyAnswersCoreDataService = CoreDataModelService<ManagedHistoryAnswer, HistoryAnswer>(
		context: historyAnswersContext,
		fetchRequest: ConfiguredFetchRequest.managedHistoryAnswersRequest,
		toModelConverter: HistoryAnswer.init
	)

	private lazy var answerSourcesCoreDataService = CoreDataModelService<ManagedAnswerSet, AnswerSet>(
		context: answerSetsContext,
		fetchRequest: ConfiguredFetchRequest.notEmptyAnswerSetsRequest,
		toModelConverter: AnswerSet.init
	)
}
