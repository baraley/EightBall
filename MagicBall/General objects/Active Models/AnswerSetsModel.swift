//
//  AnswerSetsModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol AnswerSetsService: class {

	var changesHandler: (([Change<AnswerSet>]) -> Void)? { get set }

	func loadAnswerSets()
	func numberOfAnswerSets() -> Int
	func answerSet(at index: Int) -> AnswerSet
	func upsert(_ answerSet: AnswerSet)
	func deleteAnswerSet(at index: Int)

}

protocol AnswerSetsModelObserver: class {

	func answerSetsModel(_ model: AnswerSetsModel, changesDidHappen changes: [Change<AnswerSet>])

}

final class AnswerSetsModel {

	private let answerSetsService: AnswerSetsService

	init(answerSetsService: AnswerSetsService) {
		self.answerSetsService = answerSetsService
		self.answerSetsService.changesHandler = {[weak self] (changes) in
			self?.handleChanges(changes)
		}
	}

	// MARK: - Public

	func loadAnswerSets() {
		answerSetsService.loadAnswerSets()
	}

	func numberOfAnswerSets() -> Int {
		return answerSetsService.numberOfAnswerSets()
	}

	func answerSet(at index: Int) -> AnswerSet {
		return answerSetsService.answerSet(at: index)
	}

	func save(_ answerSet: AnswerSet) {
		answerSetsService.upsert(answerSet)
	}

	func deleteAnswerSet(at index: Int) {
		answerSetsService.deleteAnswerSet(at: index)
	}

	// MARK: - Observation

	private var observations: [ObjectIdentifier: Observation] = [:]

	func addObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	// MARK: - Private

	private func handleChanges(_ changes: [Change<AnswerSet>]) {

		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				DispatchQueue.main.async {
					observer.answerSetsModel(self, changesDidHappen: changes)
				}

			} else {
				observations.removeValue(forKey: id)
			}
		}
	}

}

private extension AnswerSetsModel {

	struct Observation {
        weak var observer: AnswerSetsModelObserver?
    }

}
