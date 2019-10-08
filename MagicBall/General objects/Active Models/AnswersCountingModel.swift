//
//  AnswersCountingModel.swift
//  MagicBall
//
//  Created by Alexander Baraley on 08.10.2019.
//  Copyright © 2019 Alexander Baraley. All rights reserved.
//

import Foundation

private let loadedAnswersNumberKey = "requestedAnswersNumberKey"

protocol AnswersNumberObserver: class {

	func answersCountingModel(_ model: AnswersCountingModel, didChangeAnswersNumberTo number: Int)

}

class AnswersCountingModel {

	private let secureStorage: SecureStorage

	init (secureStorage: SecureStorage) {
		self.secureStorage = secureStorage

		answersNumber = secureStorage.value(forKey: loadedAnswersNumberKey) ?? 0
	}

	private(set) var answersNumber: Int {
		didSet {
			secureStorage.setValue(answersNumber, forKey: loadedAnswersNumberKey)
			notifyObservers()
		}
	}

	func increase() {
		answersNumber += 1
	}

	func reset() {
		answersNumber = 0
	}

	// MARK: - Observation

	private var observations: [ObjectIdentifier: Observation] = [:]

	func addObserver(_ observer: AnswersNumberObserver) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: AnswersNumberObserver) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

	private func notifyObservers() {
		observations.forEach { (id, observation) in
			if let observer = observation.observer {
				observer.answersCountingModel(self, didChangeAnswersNumberTo: answersNumber)

			} else {
				observations.removeValue(forKey: id)
			}
		}
	}

}

private extension AnswersCountingModel {

	struct Observation {
        weak var observer: AnswersNumberObserver?
    }

}
