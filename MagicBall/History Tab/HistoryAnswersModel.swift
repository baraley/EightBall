//
//  HistoryAnswersModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol HistoryAnswersService: class {

	var changesHandler: (([Change<HistoryAnswer>]) -> Void)? { get set }

	func loadHistoryAnswers()
	func numberOfHistoryAnswers() -> Int
	func historyAnswer(at index: Int) -> HistoryAnswer
	func upsert(_ historyAnswer: HistoryAnswer)
	func deleteHistoryAnswer(at index: Int)

}

final class HistoryAnswersModel {

	private let historyAnswersService: HistoryAnswersService

	init(historyAnswersService: HistoryAnswersService) {
		self.historyAnswersService = historyAnswersService
		historyAnswersService.changesHandler = { [weak self] changes in
			self?.handleChanges(changes)
		}
	}

	var historyAnswersChangesHandler: (([Change<HistoryAnswer>]) -> Void)?

	func loadHistoryAnswers() {
		historyAnswersService.loadHistoryAnswers()
	}

	func numberOfHistoryAnswers() -> Int {
		return historyAnswersService.numberOfHistoryAnswers()
	}

	func historyAnswer(at index: Int) -> HistoryAnswer {
		return historyAnswersService.historyAnswer(at: index)
	}

	func save(_ historyAnswer: HistoryAnswer) {
		historyAnswersService.upsert(historyAnswer)
	}

	func deleteHistoryAnswer(at index: Int) {
		historyAnswersService.deleteHistoryAnswer(at: index)
	}

	// MARK: - Private

	private func handleChanges(_ changes: [Change<HistoryAnswer>]) {
		DispatchQueue.main.async {
			self.historyAnswersChangesHandler?(changes)
		}
	}

}
