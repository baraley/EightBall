//
//  AnswerSetsModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 29.09.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

protocol AnswerSetsServiceProtocol {

	func loadAnswerSets() -> [ManagedAnswerSet]
	func save(_ answerSets: [AnswerSet])

}

protocol AnswerSetsModelObserver: class {

	func answerSetsModelDidChangeAnswerSets(_ model: AnswerSetsModel)

}

final class AnswerSetsModel {

	private let answerSetsService: AnswerSetsServiceProtocol

	init(answerSetsService: AnswerSetsServiceProtocol) {
		self.answerSetsService = answerSetsService
	}

	private var observations: [ObjectIdentifier: Observation] = [:]

	private var answerSets: [AnswerSet] = [] {
		didSet {
			answerSetsService.save(answerSets)
			notifyObservers()
		}
	}

	func loadAnswerSets() -> [AnswerSet] {
		return answerSetsService.loadAnswerSets().map { $0.toAnswerSet()}
	}

	func numberOfAnswerSets() -> Int {
		return answerSets.count
	}

	func answerSet(at index: Int) -> AnswerSet {
		return answerSets[index]
	}

	func save(_ answerSet: AnswerSet) {
		if let index = answerSets.firstIndex(of: answerSet) {
			answerSets[index] = answerSet
		} else {
			answerSets.append(answerSet)
		}
	}

	func deleteAnswerSet(at index: Int) {
		guard index >= 0, index < answerSets.count else { return }

		answerSets.remove(at: index)
	}

	// MARK: - Observation -

	func addObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AnswerSetsModelObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	private func notifyObservers() {
		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				observer.answerSetsModelDidChangeAnswerSets(self)

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
