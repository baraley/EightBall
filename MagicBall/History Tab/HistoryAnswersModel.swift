//
//  HistoryAnswersModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

final class HistoryAnswersModel {

	private let coreDataModelService: CoreDataModelService<ManagedHistoryAnswer, HistoryAnswer>

	init(coreDataModelService: CoreDataModelService<ManagedHistoryAnswer, HistoryAnswer>) {
		self.coreDataModelService = coreDataModelService
		coreDataModelService.changeHandler = { [weak self] changes in
			self?.handleChanges(changes)
		}
	}

	var historyAnswersChangesHandler: (([Change<HistoryAnswer>]) -> Void)?

	func loadHistoryAnswers() {
		coreDataModelService.loadModels()
	}

	func numberOfHistoryAnswers() -> Int {
		return coreDataModelService.numberOfModels()
	}

	func historyAnswer(at index: Int) -> HistoryAnswer {
		return coreDataModelService.model(at: index)
	}

	func save(_ historyAnswer: HistoryAnswer) {
		coreDataModelService.upsert(historyAnswer)
	}

	func deleteHistoryAnswer(at index: Int) {
		coreDataModelService.deleteModel(at: index)
	}

	// MARK: - Private

	private func handleChanges(_ changes: [Change<HistoryAnswer>]) {
		DispatchQueue.main.async {
			self.historyAnswersChangesHandler?(changes)
		}
	}

}
