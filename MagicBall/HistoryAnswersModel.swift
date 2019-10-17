//
//  HistoryAnswersModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 17.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol HistoryAnswerServiceProtocol: class {

	var numberOfHistoryAnswers: Int { get }

	var historyAnswerDidChangeHandler: (([HistoryAnswersModel.Change]) -> Void)? { get set }

	func loadHistoryAnswers()
	func historyAnswer(at index: Int) -> HistoryAnswer
	func insert(_ historyAnswer: HistoryAnswer)
	func deleteHistoryAnswer(at index: Int)
	func clearHistory()

}

protocol HistoryAnswerModelObserver: class {

	func historyAnswerModel(_ model: HistoryAnswersModel, changesDidHappen changes: [HistoryAnswersModel.Change])

}

final class HistoryAnswersModel {

	enum Change {
		case insert(HistoryAnswer, Int)
		case delete(HistoryAnswer, Int)
	}

	let historyAnswerService: HistoryAnswerServiceProtocol

	init(historyAnswerService: HistoryAnswerServiceProtocol) {
		self.historyAnswerService = historyAnswerService
		historyAnswerService.historyAnswerDidChangeHandler = { [weak self] changes in
			self?.handleChanges(changes)
		}
	}

	func loadHistoryAnswers() {
		historyAnswerService.loadHistoryAnswers()
	}

	func numberOfHistoryAnswers() -> Int {
		return historyAnswerService.numberOfHistoryAnswers
	}

	func historyAnswer(at index: Int) -> HistoryAnswer {
		return historyAnswerService.historyAnswer(at: index)
	}

	func save(_ historyAnswer: HistoryAnswer) {
		historyAnswerService.insert(historyAnswer)
	}

	func deleteHistoryAnswer(at index: Int) {
		guard index >= 0, index < numberOfHistoryAnswers() else { return }

		historyAnswerService.deleteHistoryAnswer(at: index)
	}

	func clearHistory() {
		historyAnswerService.clearHistory()
	}

	// MARK: - Observation

	private var observations: [ObjectIdentifier: Observation] = [:]

	func addObserver(_ observer: HistoryAnswerModelObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: HistoryAnswerModelObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	// MARK: - Private

	private func handleChanges(_ changes: [Change]) {
		DispatchQueue.main.async {
			self.notifyObservers(with: changes)
		}
	}

	private func notifyObservers(with changes: [Change]) {
		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				observer.historyAnswerModel(self, changesDidHappen: changes)

			} else {
				observations.removeValue(forKey: id)
			}
		}
	}

}

private extension HistoryAnswersModel {

	struct Observation {
        weak var observer: HistoryAnswerModelObserver?
    }

}
